require 'test_helper'

module Directo
  class ConfigurationTest < Minitest::Test
    def test_endpoint
      Directo.configure { |config| config.endpoint = 'http://example.com' }
      assert_equal 'http://example.com', Directo.configuration.endpoint
    end

    def test_sales_agent
      Directo.configure { |config| config.sales_agent = 'John Doe' }
      assert_equal 'John Doe', Directo.configuration.sales_agent
    end

    def test_payment_terms
      Directo.configure { |config| config.payment_terms = 'COD' }
      assert_equal 'COD', Directo.configuration.payment_terms
    end
  end
end
