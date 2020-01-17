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

    def deliver(ssl_verify: true)
      uri = URI(@api_url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.read_timeout = 10
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless ssl_verify

      req = Net::HTTP::Post.new(uri)
      req.set_form_data(put: 1, what: 'invoice', xmldata: as_xml)

      http.request(req)
    end

    def as_xml
      serializer = Serializer.new(@invoices)
      serializer.serialize.gsub("\n", '')
    end
  end
end
