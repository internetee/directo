require 'test_helper'

module Directo
  class Invoice
    class LineTest < Minitest::Test
      def setup
        @line = Line.new
      end

      def test_code
        @line.code = '001'
        assert_equal '001', @line.code
      end

      def test_description
        @line.description = 'Acme services'
        assert_equal 'Acme services', @line.description
      end

      def test_period
        @line.period = Date.parse('2010-07-05')..Date.parse('2010-07-06')
        assert_equal Date.parse('2010-07-05')..Date.parse('2010-07-06'), @line.period
      end

      def test_quantity
        @line.quantity = 1
        assert_equal 1, @line.quantity
      end

      def test_unit
        @line.unit = 'pc'
        assert_equal 'pc', @line.unit
      end

      def test_price
        @line.price = Money.from_amount(1)
        assert_equal Money.from_amount(1), @line.price
      end
    end
  end
end
