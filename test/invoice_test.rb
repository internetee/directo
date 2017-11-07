require 'test_helper'

module Directo
  class InvoiceTest < Minitest::Test
    def test_number
      invoice = Invoice.new
      invoice.number = '001'
      assert_equal '001', invoice.number
    end

    def test_date
      invoice = Invoice.new
      invoice.date = '2010-07-05'
      assert_equal '2010-07-05', invoice.date
    end

    def test_currency
      invoice = Invoice.new
      invoice.currency = 'EUR'
      assert_equal 'EUR', invoice.currency
    end

    def test_language
      invoice = Invoice.new
      invoice.language = 'en'
      assert_equal 'en', invoice.language
    end
  end
end
