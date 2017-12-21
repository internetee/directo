module Directo
  class Serializer
    def initialize(invoices)
      @invoices = invoices
    end

    def serialize
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.invoices {
          @invoices.each do |invoice|
            xml.invoice(serializable_invoice_hash(invoice)) {
              invoice.each do |line|
                xml.line serializable_line_hash(line)
              end
            }
          end
        }
      end

      builder.to_xml
    end

    private

    def serializable_invoice_hash(invoice)
      { Number: invoice.number,
        InvoiceDate: invoice.date,
        PaymentTerm: invoice.payment_terms,
        CustomerCode: invoice.code,
        Language: invoice.language,
        Currency: invoice.currency,
        SalesAgent: invoice.sales_agent,
        TotalVAT: invoice.vat_amount }
    end

    def serializable_line_hash(line)
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
