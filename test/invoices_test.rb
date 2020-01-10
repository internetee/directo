require 'test_helper'

module Directo
  class InvoicesTest < Minitest::Test
    def test_delivers_to_api_url
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')

      request_body = URI.encode_www_form(put: 1, what: 'invoice', xmldata: 'test')
      request_stub = stub_request(:post, 'http://directo-api.test').with(body: request_body)

      invoices = client.invoices
      invoices.deliver

      assert_requested request_stub
    end
  end
end
