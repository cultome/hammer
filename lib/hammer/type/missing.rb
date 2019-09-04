module Hammer
  module Type
    def missing
      @@missing ||= Missing.new
    end

    private

    class Missing
      include Comparable

      def nil?
        true
      end

      def inspect
        "missing"
      end

      def to_s
        ""
      end

      def method_missing(mtd, *args)
        nil
      end

      def <=>(obj)
        -1
      end
    end
  end
end
