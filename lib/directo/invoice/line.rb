module Directo
  class Invoice
    class Line
      attr_accessor :seq_no
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
