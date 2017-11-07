require 'test_helper'

module Directo
  class Invoice
    class ItemTest < Minitest::Test
      def test_code
        item = Item.new
        item.code = '001'
        assert_equal '001', item.code
      end

      def test_description
        item = Item.new
        item.description = 'Acme services'
        assert_equal 'Acme services', item.description
      end

      def test_quantity
        item = Item.new
        item.quantity = 1
        assert_equal 1, item.quantity
      end

      def test_unit
        item = Item.new
        item.unit = 'pc'
        assert_equal 'pc', item.unit
      end

      def test_price
        item = Item.new
        item.price = Money.from_amount(1)
        assert_equal Money.from_amount(1), item.price
      end
    end
  end
end
