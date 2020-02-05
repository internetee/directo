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
      case schema
      when 'prepayment'
        meta_map = Prepayment.meta_schema
        line_map = Prepayment.line_schema
      when 'summary'
        meta_map = Summary.meta_schema
        line_map = Summary.line_schema
      else
        raise ArgumentError, 'Schema argument is not valid'
      end

      meta_map.keys.each do |key|
        next unless invoice.key? meta_map[key]

        send((key.to_s + '='), invoice[meta_map[key]])
        puts "Found value for meta key #{key}: #{invoice[meta_map[key]]}"
      end

      @customer = Customer.new(name: '', code: @customer)
      invoice['invoice_lines'].each do |invoice_line|
        line = @lines.new
        line_map.keys.each do |key|
          next unless invoice_line.key? line_map[key]

          line.send((key.to_s + '='), invoice_line[line_map[key]])
          puts "Found value for line key #{key}: #{invoice_line[line_map[key]]}"
        end
        @lines.add(line)
      end
    end
  end
end
