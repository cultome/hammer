require "rubyXL"
require "hammer/util/row_type_calculator"

module Hammer::Loader
  module XLSX
    include Hammer::TypeCohersable

    def load_xlsx(filename, extras: {})
      options = xlsx_extras_defaults.merge(extras)

      workbook = RubyXL::Parser.parse(filename)
      worksheet = workbook[options["worksheet_idx"].to_i]

      headers = xlsx_headers(worksheet)
      data, types = xlsx_content(worksheet, extras: options)
      metadata = {
        available_sheets: workbook.sheets.map.with_index{|s,idx| "[#{idx}] #{s.name}"}.join(", "),
        sheet_name: worksheet.sheet_name,
      }

      build_dataframe(data: data, column_names: headers, column_types: types, metadata: metadata)
    end

    private

    def xlsx_extras_defaults
      {
        "worksheet_idx" => 0,
        "fullload" => false,
        "load_only" => 10,
      }
    end

    def xlsx_headers(worksheet)
      worksheet[0].cells.map{|col| col.value}
    end

    def xlsx_content(worksheet, extras: {})
      idx = 1
      data = []
      calculator = Hammer::Util::RowTypeCalculator.new

      loop do
        break if worksheet[idx].nil?

        unless extras.fetch("fullload", false)
          break if idx >= extras.fetch("load_only", 10)
        end

        row_data = worksheet[idx].cells.map{|col| col.nil? ? nil : col.value}
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
