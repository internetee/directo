require 'test_helper'

module Directo
  class SerializerTest < Minitest::Test
    def test_serialize
      Directo.configure do |config|
        config.sales_agent = 'John Doe'
        config.payment_terms = 'net10'
      end

      customer = Customer.new
      customer.code = 'CUST1'

      invoice = Invoice.new do |invoice|
        invoice.customer = customer
        invoice.number = 1
        invoice.date = Date.parse('2010-07-05')
        invoice.currency = Money::Currency.new('EUR')
        invoice.language = 'ENG'
        invoice.vat_amount = Money.from_amount(1)
      end

      line = Invoice::Line.new do |line|
        line.code = 'CODE1'
        line.description = 'Acme services'
        line.price = Money.from_amount(1)
        line.quantity = 2
        line.unit = 'pc'
        line.period = Date.parse('2010-07-05')..Date.parse('2010-07-06')
        line.vat_number = 'US1'
      end

      invoice.add_line(line)
      serializer = Serializer.new([invoice])

      xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="CUST1" Language="ENG" 
            Currency="EUR" SalesAgent="John Doe" TotalVAT="1.00">
            <line RN="1" ProductID="CODE1" Quantity="2" Unit="pc" ProductName="Acme services" UnitPriceWoVAT="1.00" 
            VATCode="US1" StartDate="2010-07-05" EndDate="2010-07-06" />
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(xml, nil, 'UTF-8') { |config| config.noblanks }.to_s,
                   Nokogiri::XML(serializer.serialize) { |config| config.noblanks }.to_s
    end
  end
end
