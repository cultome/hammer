require "csv"

module Hammer::Loader
  module CSV
    include Hammer::TypeCohersable

    def load_csv(filename, extras: {})
      options = csv_extras_defaults.merge(extras)

      csv = ::CSV.open(filename)
      if options.fetch("fullload", true)
        data = csv.readlines
      else
        data = csv.take(options.fetch("load_only", 10))
      end

      headers = get_headers(data)
      formatted_data = apply_format(data, extras: options)

      Hammer::Structure::Dataframe.new(data: formatted_data, column_names: headers)
    end

    private

    def csv_extras_defaults
      {
        "fullload" => false,
        "load_only" => 10,
      }
    end

    def get_headers(data)
      header_types = data.first.map{|v| detect_type(v)}
      first_row_types = data[1].map{|v| detect_type(v)}

      return data.shift if header_types != first_row_types
      nil
    end

    def apply_format(data, extras: {})
      data.map.with_index do |row,idx|
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
