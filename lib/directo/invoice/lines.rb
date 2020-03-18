module DirectoApi
  class Invoice
    class Lines
      attr_reader :lines

      def initialize(lines = [])
        @lines = populate_with_seq_no(lines)
      end

      def each(&block)
        lines.each(&block)
      end

      def new
        Invoice::Line.new
      end

      def add(line)
        lines.push(line)
        @lines = populate_with_seq_no(lines)
      end

      private

      def populate_with_seq_no(lines)
        lines.each_with_index do |line, index|
          seq_no = index.next
          line.seq_no = seq_no
        end
      end
    end
  end
end
