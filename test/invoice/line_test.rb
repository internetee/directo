require 'test_helper'

module DirectoApi
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

      def test_link_id_returns_seq_no_if_parent_is_absent
        @line.seq_no = 1
        assert_equal 1, @line.link_id
      end

      def test_link_id_returns_parent_seq_no_if_parent_is_present
        parent = Line.new
        parent.seq_no = 2

        @line.parent = parent

        assert_equal 2, @line.link_id
      end
    end
  end
end
