module Directo
  class Invoice
    extend Forwardable

    attr_accessor :customer # CustomerCode
    attr_accessor :number # Number
    attr_accessor :date # InvoiceDate
    attr_accessor :currency # Currency
    attr_accessor :language # Language
    attr_accessor :total_wo_vat # TotalWoVAT
    attr_accessor :vat_amount # TotalVAT, VAT percentage
    attr_accessor :lines
    attr_accessor :payment_terms
    attr_accessor :sales_agent
    # PaymentTerm: invoice.payment_terms
    # SalesAgent: invoice.sales_agent

    def_delegator :@customer, :code, :customer_code
    def_delegator :@customer, :name, :customer_name
    def_delegator :@lines, :each

    def initialize(_lines = nil, sales_agent = nil, payment_terms = nil)
      @sales_agent = sales_agent
      @payment_terms = payment_terms
      @lines ||= Invoice::Lines.new
      yield self if block_given?
    end
  end
end
