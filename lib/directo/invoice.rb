module DirectoApi
  class Invoice
    extend Forwardable

    attr_accessor :customer
    attr_accessor :number
    attr_accessor :date
    attr_accessor :transaction_date
    attr_accessor :currency
    attr_accessor :language
    attr_accessor :total_wo_vat
    attr_accessor :vat_amount
    attr_accessor :lines
    attr_accessor :payment_terms
    attr_accessor :sales_agent
    def_delegator :@customer, :code, :customer_code
    def_delegator :@customer, :name, :customer_name
    def_delegator :@lines, :each

    def initialize(_lines = nil, sales_agent = nil, payment_terms = nil)
      @sales_agent = sales_agent
      @payment_terms = payment_terms
      @lines ||= Invoice::Lines.new
      yield self if block_given?
    end

    def load_from_schema(invoice:, schema:)
      schema = Object.const_get('DirectoApi::' + schema.capitalize)

      schema_to_invoice(schema: schema, invoice: invoice)
      @customer = attach_invoice_customer(invoice)

      invoice_lines = remove_line_duplicates(invoice['invoice_lines'])
      create_lines_from_schema(invoice_lines, line_map: schema.line_schema)
    end

    private

    def schema_to_invoice(schema:, invoice:)
      schema.meta_schema.keys.each do |key|
        next unless invoice.key? schema.meta_schema[key]

        send((key.to_s + '='), invoice[schema.meta_schema[key]])
      end
    end

    def attach_invoice_customer(invoice)
      if invoice['customer'].class == Hash
        Customer.new(name: invoice['customer']['name'],
                     code: invoice['customer']['code'])
      else
        Customer.new(code: customer, name: nil)
      end
    end

    def create_lines_from_schema(invoice_lines, line_map:)
      invoice_lines.each do |invoice_line|
        line = @lines.new
        line_map.keys.each do |key|
          next unless invoice_line.key? line_map[key]

          line.send((key.to_s + '='), invoice_line[line_map[key]])
        end
        create_line_entry(line)
      end
    end

    def create_line_entry(line)
      unless line.start_date.nil?
        parent = @lines.each.find_all { |l| l.description == line.description }.first
        line.parent = parent if parent
      end
      @lines.add(line)
    end

    def remove_line_duplicates(invoice_lines, lines: [])
      line_map = Hash.new 0
      invoice_lines.each { |l| line_map[l] += 1 }

      line_map.keys.each do |count|
        count['quantity'] = line_map[count] unless count['unit'].nil?
        if count['description'].match?(/Domeenide ettemaks|Domains prepayment/)
          count['quantity'] = -1
        end

        lines << count
      end

      lines
    end
  end
end
