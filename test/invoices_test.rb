# frozen_string_literal: true

require 'test_helper'
require 'json'

module DirectoApi
  class InvoicesTest < Minitest::Test
    def test_can_create_summary_from_schema
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')
      invoice = JSON.parse({ currency: 'EUR', date: '2010-07-05', customer_code: 'bestnames',
                             language: 'ENG', number: '1',
                             invoice_lines: [
                               { product_id: 'COM01', description: '.ee registreerimine - 1 aasta(t)',
                                 quantity: 1, price: '5.00', period: '1',
                                 unit: 'pc' }
                             ] }.to_json)

      client.invoices.add_with_schema(schema: 'summary', invoice: invoice)

      expected_xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="bestnames" Language="ENG" Currency="EUR" SalesAgent="John Doe">
            <line RN="1" RR="1" ProductID="COM01" Quantity="1" Unit="pc" ProductName=".ee registreerimine - 1 aasta(t)" UnitPriceWoVAT="5.00" VATCode="0"/>
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(expected_xml, nil, 'UTF-8', &:noblanks).to_s,
                   Nokogiri::XML(client.invoices.as_xml, &:noblanks).to_s
    end

    def test_can_create_prepayment_from_schema
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')
      invoice = JSON.parse({ due_date: '2010-07-06', currency: 'EUR',
                             vat_rate: '10.0', issue_date: '2010-07-05', customer_code: 'bestnames',
                             transaction_date: '2010-08-06', language: 'ENG', number: '1',
                             invoice_lines: [
                               { product_id: 'ETTEM06', description: 'Domains prepayment',
                                 quantity: -1, price: '5.00' }
                             ] }.to_json)

      client.invoices.add_with_schema(schema: 'prepayment', invoice: invoice)

      expected_xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="bestnames" Language="ENG" Currency="EUR" SalesAgent="John Doe" TransactionDate="2010-08-06">
            <line RN="1" RR="1" ProductID="ETTEM06" Quantity="-1" ProductName="Domains prepayment" UnitPriceWoVAT="5.00" VATCode="0"/>
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(expected_xml, nil, 'UTF-8', &:noblanks).to_s,
                   Nokogiri::XML(client.invoices.as_xml, &:noblanks).to_s
    end

    def test_can_create_auction_invoice_from_schema
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')
      invoice = JSON.parse({ due_date: '2010-07-06', currency: 'EUR',
                             vat_rate: '10.0', issue_date: '2010-07-05', customer: { code: 'bestnames', name: 'Best Names' },
                             transaction_date: '2010-08-06', language: 'ENG', number: '1',
                             invoice_lines: [
                               { product_id: 'OKSJON', description: 'auction for .ee',
                                 quantity: 1, price: '5.00' }
                             ] }.to_json)

      client.invoices.add_with_schema(schema: 'auction', invoice: invoice)

      expected_xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="bestnames"  CustomerName="Best Names" Language="ENG" Currency="EUR" SalesAgent="John Doe" TransactionDate="2010-08-06">
            <line RN="1" RR="1" ProductID="OKSJON" Quantity="1" ProductName="auction for .ee" UnitPriceWoVAT="5.00" VATCode="0"/>
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(expected_xml, nil, 'UTF-8', &:noblanks).to_s,
                   Nokogiri::XML(client.invoices.as_xml, &:noblanks).to_s
    end

    def test_can_determine_vat_rate_from_schema
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')
      invoice = JSON.parse({ due_date: '2010-07-06', currency: 'EUR',
                             vat_rate: '10.0', issue_date: '2010-07-05', customer: { code: 'bestnames', name: 'Best Names', destination: 'EE', vat_reg_no: '123' },
                             transaction_date: '2010-08-06', language: 'ENG', number: '1',
                             invoice_lines: [
                               { product_id: 'OKSJON', description: 'auction for .ee',
                                 quantity: 1, price: '5.00' }
                             ] }.to_json)

      client.invoices.add_with_schema(schema: 'auction', invoice: invoice)

      expected_xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="bestnames"  CustomerName="Best Names" Destination="EE" VATregNo="123" Language="ENG" Currency="EUR" SalesAgent="John Doe" TransactionDate="2010-08-06">
            <line RN="1" RR="1" ProductID="OKSJON" Quantity="1" ProductName="auction for .ee" UnitPriceWoVAT="5.00" VATCode="10"/>
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(expected_xml, nil, 'UTF-8', &:noblanks).to_s,
                   Nokogiri::XML(client.invoices.as_xml, &:noblanks).to_s
    end

    def test_can_determine_vat_rate_from_schema_if_reverse_vat_charge
      client = Client.new('http://directo-api.test', 'John Doe', 'net10')
      invoice = JSON.parse({ due_date: '2010-07-06', currency: 'EUR',
                             vat_rate: '10.0', issue_date: '2010-07-05', customer: { code: 'bestnames', name: 'Best Names', destination: 'CZ', vat_reg_no: '123' },
                             transaction_date: '2010-08-06', language: 'ENG', number: '1',
                             invoice_lines: [
                                 { product_id: 'OKSJON', description: 'auction for .ee',
                                   quantity: 1, price: '5.00' }
                             ] }.to_json)

      client.invoices.add_with_schema(schema: 'auction', invoice: invoice)
      vat_code = DirectoApi::Invoice::DEFAULT_REVERSE_CHARGE_VAT_CODE

      expected_xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="bestnames"  CustomerName="Best Names" Destination="CZ" VATregNo="123" Language="ENG" Currency="EUR" SalesAgent="John Doe" TransactionDate="2010-08-06">
             <line RN="1" RR="1" ProductID="OKSJON" Quantity="1" ProductName="auction for .ee" UnitPriceWoVAT="5.00" VATCode="#{vat_code}" />
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
