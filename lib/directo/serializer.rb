module DirectoApi
  class Serializer
    def initialize(invoices)
      @invoices = invoices
    end

    def serialize
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.invoices do
          @invoices.each do |invoice|
            xml.invoice(invoice_to_hash(invoice)) do
              invoice.lines.each do |line|
                xml.line line_to_hash(line)
              end
            end
          end
        end
      end
      builder.to_xml
    end

    private

    def invoice_to_hash(invoice)
      invoice_hash = compose_invoice_from_hash(invoice)

      if invoice.transaction_date
        invoice_hash[:TransactionDate] = invoice.transaction_date
      end

      invoice_hash.reject { |k, v| ((k.to_s != 'Language') && v.to_s.empty?) }
    end

    def compose_invoice_from_hash(invoice)
      { Number: invoice.number, InvoiceDate: invoice.date,
        PaymentTerm: invoice.payment_terms,
        CustomerCode: invoice.customer_code,
        CustomerName: invoice.customer_name,
        Language: invoice.language, Currency: invoice.currency,
        SalesAgent: invoice.sales_agent,
        TotalVAT: invoice.vat_amount,
        TotalWoVAT: invoice.total_wo_vat }
    end

    def compose_line_from_hash(line)
      { RN: line.seq_no,
        RR: line.link_id,
        ProductID: line.code,
        Quantity: line.quantity,
        Unit: line.unit,
        ProductName: line.description,
        UnitPriceWoVAT: line.price,
        VATCode: line.vat_number }
    end

    def line_to_hash(line)
      line_hash = compose_line_from_hash(line)

      attach_product_timeframe(line_hash, line)

      line_hash.reject { |_k, v| v.to_s.empty? }
    end

    def attach_product_timeframe(hash, line)
      return unless line.start_date && line.end_date

      hash[:StartDate] = line.start_date
      hash[:EndDate] = line.end_date
    end
  end
end
