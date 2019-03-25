require "csv"

module Hammer::Loader
  module CSV
    include Hammer::TypeCohersable

    def load_csv(filename)
      data = ::CSV.open(filename).readlines

      # TODO handle the header
      data.shift

      formatted_data = apply_format(data)

      Dataframe.new(data: formatted_data)
    end

    private

    def apply_format(data)
      data.map do |row|
        apply_row_format(row)
      end
    end

    def apply_row_format(row)
      row.map do |value|
        detect_type_and_cast(value)
      end
    end
  end
end
