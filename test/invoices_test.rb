require 'test_helper'
require 'json'
module DirectoApi
  class InvoicesTest < Minitest::Test
    def test_can_create_summary_from_schema
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')
      invoice = JSON.parse({ due_date: '2010-07-06', currency: 'EUR',
                             description: 'Order nr 1 from registrar 1234567 second number 2345678',
                             vat_rate: '10.0', issue_date: '2010-07-05', customer_code: 'bestnames',
                             transaction_date: '2010-08-06', language: 'ENG', number: '1',
                             invoice_lines: [
                               { product_id: 'ETTEM06', description: 'Order nr. 1',
                                 quantity: 1, price: '5.00' },
                             ] }.to_json)

      client.invoices.add_with_schema(schema: 'prepayment', invoice: invoice)

      expected_xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="bestnames" Language="ENG" Currency="EUR" SalesAgent="John Doe" TransactionDate="2010-08-06">
            <line RN="1" RR="1" ProductID="ETTEM06" Quantity="1" ProductName="Order nr. 1" UnitPriceWoVAT="5.00"/>
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(expected_xml, nil, 'UTF-8', &:noblanks).to_s,
                   Nokogiri::XML(client.invoices.as_xml, &:noblanks).to_s
    end

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
