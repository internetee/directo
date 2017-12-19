require 'test_helper'

module Directo
  class CustomerTest < Minitest::Test
    def setup
      @customer = Customer.new
    end

    def test_code
      @customer.code = 'CUST001'
      assert_equal 'CUST001', @customer.code
    end
  end
end
