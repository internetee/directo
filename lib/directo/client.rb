module DirectoApi
  class Client
    attr_accessor :api_url, :sales_agent, :invoices, :payment_terms

    def initialize(api_url = nil, sales_agent = nil, payment_terms = nil)
      @api_url = api_url
      @sales_agent = sales_agent
      @payment_terms = payment_terms
      @invoices = Invoices.new([], @api_url, @sales_agent, @payment_terms)
    end
  end
end
