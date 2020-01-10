module Directo
  class Invoices
    extend Forwardable

    def_delegator :@invoices, :each

    def initialize(invoices = [], api_url = nil, sales_agent = nil, payment_terms = nil)
      @invoices = invoices
      @api_url = api_url
      @payment_terms = payment_terms
      @sales_agent = sales_agent
    end

    def each(&block)
      @invoices.each(&block)
    end

    def new
      Invoice.new(nil, @sales_agent, @payment_terms)
    end

    def add(invoice)
      @invoices.push(invoice)
    end

    def deliver
      uri = URI(@api_url)
      serializer = Serializer.new(@invoices)
      xmldata = serializer.serialize.gsub("\n", '')
      Net::HTTP.post_form(uri, put: '1', what: 'invoice', xmldata: xmldata)
    end
  end
end
