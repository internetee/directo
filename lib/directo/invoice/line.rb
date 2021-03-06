module DirectoApi
  class Invoice
    class Line
      attr_accessor :seq_no # RN
      attr_accessor :code # ProductID
      attr_accessor :description # ProductName

      # Date.parse('2010-07-05')..Date.parse('2010-07-06')
      attr_accessor :period # StartDate  / EndDate
      attr_accessor :start_date
      attr_accessor :end_date

      attr_accessor :vat_number # VATCode, directo internal code
      attr_accessor :quantity # Quantity
      attr_accessor :unit # Unit
      attr_accessor :price # UnitPriceWoVAT

      def initialize
        yield self if block_given?
      end

      def parent=(line)
        @parent = line
      end

      def link_id
        return seq_no unless has_parent?

        @parent.seq_no
      end

      private

      def has_parent?
        !@parent.nil?
      end
    end
  end
end
