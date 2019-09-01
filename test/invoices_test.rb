require 'test_helper'

module Directo
  class InvoicesTest < Minitest::Test
    def test_delivers_to_api_endpoint
      Directo.configure do |config|
        config.endpoint = 'http://directo-api.test'
      end

      request_body = URI.encode_www_form(put: 1, what: 'invoice', xmldata: 'test')
      request_stub = stub_request(:post, 'http://directo-api.test').with(body: request_body)

      invoices = Invoices.new([])
      invoices.deliver

      assert_requested request_stub
    end
  end
end
