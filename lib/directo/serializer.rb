module Directo
  class Serializer
    def initialize(invoices)
      @invoices = invoices
    end

    def serialize
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.invoices {
          @invoices.each do |invoice|
            xml.invoice(Number: invoice.number,
                        InvoiceDate: invoice.date,
                        PaymentTerm: invoice.payment_terms,
                        CustomerCode: invoice.code,
                        Language: invoice.language,
                        Currency: invoice.currency,
                        SalesAgent: invoice.sales_agent,
                        TotalVAT: invoice.vat_amount) {
              invoice.lines.each do |line|
                xml.line(ProductID: line.code,
                         Quantity: line.quantity,
                         Unit: line.unit,
                         ProductName: line.description,
                         UnitPriceWoVAT: line.price,
                         VATCode: line.vat_number,
                         StartDate: line.period.begin,
                         EndDate: line.period.end)
              end
            }
          end
        }
      end

      builder.to_xml
    end
  end
end
