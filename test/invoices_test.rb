require 'test_helper'

module Directo
  class InvoicesTest < Minitest::Test
    def test_delivers_to_api_endpoint
      Directo.configure do |config|
        config.endpoint = 'http://directo-api.test'
      end

      request_body = URI.encode_www_form(put: 1, what: 'invoice', xmldata: 'test')
      response_body = <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <results>
          <Result Type="0" Desc="OK" docid="123" doctype="INVOICE" submit="Invoices" />
        </results>
      XML
      stub_request(:post, 'http://directo-api.test').to_return(status: 200, body: response_body)

      invoices = Invoices.new([])
      invoices.deliver

      assert_requested :post, 'http://directo-api.test', body: request_body
    end
  end
end
