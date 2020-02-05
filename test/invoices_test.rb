require 'test_helper'

module DirectoApi
  class InvoicesTest < Minitest::Test
    def test_delivers_to_api_url
      WebMock::Config.instance.query_values_notation = :flat_array

      client = Client.new('http://directo-api.test', 'John Doe', 'net10')

      xmldata = '<?xml version="1.0" encoding="UTF-8"?><invoices/>'
      request_body = URI.encode_www_form(put: 1, what: 'invoice', xmldata: xmldata)
      request_stub = stub_request(:post, 'http://directo-api.test').with(body: request_body)

      invoices = client.invoices
      invoices.deliver

      assert_requested request_stub
    end
  end
end
