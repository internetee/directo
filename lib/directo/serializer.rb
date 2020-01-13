module Directo
  class Serializer
    def initialize(invoices)
      @invoices = invoices
    end

    def serialize
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.invoices {
          @invoices.each do |invoice|
            xml.invoice(invoice_to_hash(invoice)) {
              invoice.lines.each do |line|
                xml.line line_to_hash(line)
              end
            }
          end
        }
      end

      builder.to_xml
    end

    private

    def invoice_to_hash(invoice)
      { Number: invoice.number,
        InvoiceDate: invoice.date,
        PaymentTerm: invoice.payment_terms,
        CustomerCode: invoice.customer_code,
        CustomerName: invoice.customer_name,
        Language: invoice.language,
        Currency: invoice.currency,
        SalesAgent: invoice.sales_agent,
        TotalVAT: invoice.vat_amount }
    end

    def line_to_hash(line)
      hash = { RN: line.seq_no,
               RR: line.link_id,
               ProductID: line.code,
               Quantity: line.quantity,
               Unit: line.unit,
               ProductName: line.description,
               UnitPriceWoVAT: line.price,
               VATCode: line.vat_number }

      if line.period
        hash[:StartDate] = line.period.begin
        hash[:EndDate] = line.period.end
      end

      hash
    end
  end
end
