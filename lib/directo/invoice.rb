module DirectoApi
  class Invoice
    extend Forwardable

    attr_accessor :customer, :number, :date, :transaction_date, :currency,
                  :language, :total_wo_vat, :vat_amount, :lines, :payment_terms,
                  :sales_agent

    def_delegator :@customer, :code, :customer_code
    def_delegator :@customer, :name, :customer_name
    def_delegator :@customer, :destination, :customer_destination
    def_delegator :@customer, :vat_reg_no, :customer_vat_reg_no
    def_delegator :@lines, :each

    DEFAULT_REVERSE_CHARGE_VAT_CODE = 4
    ZERO_VAT_CODE = 6

    def initialize(_lines = nil, sales_agent = nil, payment_terms = nil)
      @sales_agent = sales_agent
      @payment_terms = payment_terms
      @lines ||= Invoice::Lines.new
      yield self if block_given?
    end

    def self.vat_codes
      @vat_codes ||= JSON.parse(File.read(File.join(File.dirname(__FILE__), 'data/vat.json')))
    end

    def load_from_schema(invoice:, schema:)
      schema = Object.const_get("DirectoApi::#{schema.capitalize}")

      schema_to_invoice(schema: schema, invoice: invoice)
      @customer = attach_invoice_customer(invoice)

      logger.info 'Generating invoice lines from the following invoice:\n\r'
      logger.info invoice
      invoice_lines = remove_line_duplicates(invoice['invoice_lines'])
      lines = create_lines_from_schema(invoice_lines, line_map: schema.line_schema)
      logger.info 'Got new lines:'
      logger.info lines
      lines
    end

    def country_vat_code(iso_country)
      hash = self.class.vat_codes
      return 0 unless hash.key? iso_country

      hash[iso_country]['directo_code']
    end

    private

    def schema_to_invoice(schema:, invoice:)
      schema.meta_schema.each_key do |key|
        next unless invoice.key? schema.meta_schema[key]

        send("#{key}=", invoice[schema.meta_schema[key]])
      end
    end

    def attach_invoice_customer(invoice)
      if invoice['customer'].instance_of?(Hash)
        Customer.new(name: invoice['customer']['name'],
                     code: invoice['customer']['code'],
                     destination: invoice['customer']['destination'],
                     vat_reg_no: invoice['customer']['vat_reg_no'])
      else
        Customer.new(code: invoice['customer_code'], name: nil)
      end
    end

    def create_lines_from_schema(invoice_lines, line_map:)
      invoice_lines.each do |invoice_line|
        line = @lines.new
        line_map.each_key do |key|
          next unless invoice_line.key? line_map[key]

          line.send("#{key}=", invoice_line[line_map[key]])
        end

        create_line_entry(line)
      end
    end

    def create_line_entry(line)
      unless line.start_date.nil?
        parent = @lines.each.find_all { |l| l.description == line.description }.first
        line.parent = parent if parent
      end

      line.vat_number = calculate_vat_number
      logger.info "Calculated VAT number for line: #{line.vat_number}"
      @lines.add(line)
    end

    def calculate_vat_number
      if @customer.send_vat_code?
        country_vat_code(@customer.destination)
      elsif @customer.reverse_charge?
        DEFAULT_REVERSE_CHARGE_VAT_CODE
      else
        ZERO_VAT_CODE
      end
    end

    def remove_line_duplicates(invoice_lines, lines: [])
      line_map = Hash.new 0
      invoice_lines.each { |l| line_map[l] += 1 }

      line_map.each_key do |count|
        count['quantity'] = line_map[count] unless count['unit'].nil?
        count['quantity'] = -1 if count['description'].match?(/ettemaks|prepayment/)
        lines << count
      end

      lines
    end

    def logger
      DirectoApi.logger
    end
  end
end

