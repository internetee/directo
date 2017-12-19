require 'test_helper'

module Directo
  class InvoiceTest < Minitest::Test
    def setup
      @invoice = Invoice.new
    end

    def test_number
      @invoice.number = '001'
      assert_equal '001', @invoice.number
    end

    def test_date
      @invoice.date = Date.parse('2010-07-05')
      assert_equal Date.parse('2010-07-05'), @invoice.date
    end

    def test_delegates_code_to_customer
      customer = Customer.new
      @invoice.customer = customer

      customer.stub(:code, 'CUST001') do
        assert_equal 'CUST001', @invoice.code
      end
    end

    def test_configures_payment_terms
      Directo.configure do |config|
        config.payment_terms = 'net10'
      end

      assert_equal 'net10', @invoice.payment_terms
    end

    def test_configures_sales_agent
      Directo.configure do |config|
        config.sales_agent = 'John Doe'
      end

      assert_equal 'John Doe', @invoice.sales_agent
    end

    def test_currency
      @invoice.currency = Money::Currency.new('EUR')
      assert_equal Money::Currency.new('EUR'), @invoice.currency
    end

    def test_language
      @invoice.language = 'en'
      assert_equal 'en', @invoice.language
    end

    def test_vat_amount
      @invoice.vat_amount = Money.from_amount(1)
      assert_equal Money.from_amount(1), @invoice.vat_amount
    end

    def test_adds_line
      line = Invoice::Line.new
      @invoice.add_line(line)
      assert_includes @invoice.lines, line
    end
  end
end
