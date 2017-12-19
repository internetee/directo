module Directo
  class Invoice
    class Line
      attr_accessor :code
      attr_accessor :description
      attr_accessor :period
      attr_accessor :vat_number
      attr_accessor :quantity
      attr_accessor :unit
      attr_accessor :price

      def initialize
        yield self if block_given?
      end
    end
  end
end
