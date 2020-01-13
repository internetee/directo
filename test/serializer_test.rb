require 'test_helper'

module Directo
  class SerializerTest < Minitest::Test
    def test_serialize

      customer = Customer.new
      customer.code = 'CUST1'
      customer.name = 'CUSTOMER NAME'

      client = Client.new(nil, 'John Doe', 'net10')

      invoices = client.invoices

      inv = client.invoices.new
      inv.customer = customer
      inv.number = 1
      inv.date = Date.parse('2010-07-05')
      inv.currency = Money::Currency.new('EUR')
      inv.language = 'ENG'
      inv.vat_amount = Money.from_amount(1)

      parent_line = Invoice::Line.new do |line|
        line.code = 'CODE1'
        line.description = 'Acme services'
        line.price = Money.from_amount(1)
        line.quantity = 2
        line.unit = 'pc'
        line.vat_number = 'US1'
      end

      child_line = parent_line.dup
      child_line.period = Date.parse('2010-07-05')..Date.parse('2010-07-06')
      child_line.parent = parent_line

      inv.lines = Invoice::Lines.new([parent_line, child_line])
      client.invoices.add(inv)
      serializer = Serializer.new(invoices)

      xml = <<-XML
        <invoices>
          <invoice Number="1" InvoiceDate="2010-07-05" PaymentTerm="net10" CustomerCode="CUST1" Language="ENG"
            Currency="EUR" SalesAgent="John Doe" TotalVAT="1.00">
            <line RN="1" RR="1" ProductID="CODE1" Quantity="2" Unit="pc" ProductName="Acme services"
            UnitPriceWoVAT="1.00" VATCode="US1" />
            <line RN="2" RR="1" ProductID="CODE1" Quantity="2" Unit="pc" ProductName="Acme services"
            UnitPriceWoVAT="1.00" VATCode="US1" StartDate="2010-07-05" EndDate="2010-07-06" />
          </invoice>
        </invoices>
      XML

      assert_equal Nokogiri::XML(xml, nil, 'UTF-8') { |config| config.noblanks }.to_s,
                   Nokogiri::XML(serializer.serialize) { |config| config.noblanks }.to_s
    end
  end
end
