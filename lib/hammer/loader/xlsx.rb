require "rubyXL"

module Hammer::Loader
  module XLSX
    include Hammer::TypeCohersable

    def load_xlsx(filename)
      workbook = RubyXL::Parser.parse(filename)
      worksheet = workbook[0]

      headers = get_xlsx_headers(worksheet)
      data, types = get_sheet_info(worksheet)
      Hammer::Structure::Dataframe.new(data: data, column_names: headers, column_types: types)
    end

    class RowTypeCalculator
      def initialize
        @cols = []
      end

      def add(row_types)
        init(row_types.size)

        row_types.each_with_index do |type,idx|
          @cols[idx][type] += 1
        end
      end

      def detected_types
        @cols.map{|col| col.max{|a,b| a[1] <=> b[1]}.first}
      end

      def init(col_count)
        col_count.times{|idx| @cols[idx] ||= Hash.new{|h,k| h[k] = 0}}
      end
    end

    private

    def get_xlsx_headers(worksheet)
      worksheet[0].cells.map{|col| col.value}
    end

    def get_sheet_info(worksheet)
      idx = 1
      data = []
      calculator = RowTypeCalculator.new

      loop do
        break if worksheet[idx].nil?

        row_data = worksheet[idx].cells.map{|col| col.value}
        row_types = row_data.map{|value| detect_type(value.to_s)}

        data << row_data
        calculator.add row_types

        idx += 1
      end

      detected_types = calculator.detected_types

      [data, detected_types]
    end
  end
end
