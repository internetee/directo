module Directo
  class Invoice
    extend Forwardable

    attr_accessor :customer
    attr_accessor :number
    attr_accessor :date
    attr_accessor :currency
    attr_accessor :language
    attr_accessor :vat_amount
    attr_writer :lines

    def_delegator :@customer, :code
    def_delegator :@lines, :each

    def initialize
      @lines = []
      yield self if block_given?
    end

    def payment_terms
      Directo.configuration.payment_terms
    end

    def sales_agent
      Directo.configuration.sales_agent
    end
  end
end
