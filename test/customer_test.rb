require 'test_helper'

module DirectoApi
  class CustomerTest < Minitest::Test
    def setup
      @customer = Customer.new
    end

    def test_code
      @customer.code = 'CUST001'
      assert_equal 'CUST001', @customer.code
    end

    def test_name
      @customer.name = 'CUSTOMER NAME'
      assert_equal 'CUSTOMER NAME', @customer.name
    end

    def test_eu_based
      @customer.destination = 'CZ'
      assert @customer.eu_based?
    end

    def test_estonian_not_eu
      @customer.destination = 'EE'
      assert @customer.estonian?
      refute @customer.eu_based?
    end

    def test_non_eu_based
      @customer.destination = 'US'
      refute @customer.eu_based?
    end

    def test_not_show_vat_for_eu_based
      @customer.destination = 'CZ'
      @customer.vat_reg_no = '11111'
      refute @customer.send_vat_code?
      assert @customer.reverse_charge?
    end

    def test_show_vat_for_estonian
      @customer.destination = 'EE'
      assert @customer.send_vat_code?
    end

    def test_show_vat_for_eu
      @customer.destination = 'CZ'
      assert @customer.send_vat_code?
    end

    def test_not_show_vat_for_non_eu
      @customer.destination = 'US'
      refute @customer.send_vat_code?
    end
  end
end
