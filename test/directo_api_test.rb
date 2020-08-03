require 'test_helper'

class DirectoApiTest < Minitest::Test

  def test_logger_included
    assert DirectoApi.respond_to?(:logger)
    assert DirectoApi.respond_to?(:logger=)
  end
end
