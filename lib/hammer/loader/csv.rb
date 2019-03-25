require "csv"

module Hammer::Loader
  module CSV
    include Hammer::TypeCohersable

    def load_csv(filename)
      data = ::CSV.open(filename).readlines

      headers = get_headers(data)
      formatted_data = apply_format(data)

      Dataframe.new(data: formatted_data, column_names: headers)
    end

    private

    def get_headers(data)
      header_types = data.first.map{|v| detect_type(v)}
      first_row_types = data[1].map{|v| detect_type(v)}

      return data.shift if header_types != first_row_types
      nil
    end

    def apply_format(data)
      data.map do |row|
        apply_row_format(row)
      end
    end

    def apply_row_format(row)
      row.map do |value|
        type = detect_type(value)
        coherse(value, type)
      end
    end
  end
end
