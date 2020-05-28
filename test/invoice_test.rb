require 'test_helper'

module DirectoApi
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
        assert_equal 'CUST001', @invoice.customer_code
      end
    end

    def test_delegates_name_to_customer
      customer = Customer.new
      @invoice.customer = customer

      customer.stub(:name, 'CUSTOMER NAME') do
        assert_equal 'CUSTOMER NAME', @invoice.customer_name
      end
    end

    def test_delegates_destination_to_customer
      customer = Customer.new
      @invoice.customer = customer

      customer.stub(:destination, 'EE', ) do
        assert_equal 'EE', @invoice.customer_destination
      end
    end

    def test_delegates_vat_no_to_customer
      customer = Customer.new
      @invoice.customer = customer

      customer.stub(:vat_reg_no, 123) do
        assert_equal 123, @invoice.customer_vat_reg_no
      end
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
  end
end
