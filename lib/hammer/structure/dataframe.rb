require "set"

module Hammer::Structure
  class Dataframe
    include Hammer::TypeCohersable

    def initialize(data: [], column_names: nil, column_types: nil)
      @vectors = {}

      data.each_with_index do |row,ridx|
        row.each_with_index do |col_value,cidx|
          col_name = column_name(column_names, cidx)
          col_type = column_type(column_types, cidx, col_value)

          if @vectors.has_key? col_name
            @vectors[col_name].push(value: col_value, value_type: col_type)
          else
            @vectors[col_name] = Vector.new(data: [col_value], name: col_name, type: col_type)
          end
        end
      end
    end

    def get(column_name)
      @vectors.fetch(column_name)
    end

    def size
      if @vectors.first.nil?
        0
      else
        @vectors.first.last.size
      end
    end

    def columns
      @vectors.values
    end

    private

    def column_type(column_types, idx, value)
      if column_types.nil?
        translate_class_to_type(value.class)
      else
        column_types[idx]
      end
    end

    def column_name(column_names, idx)
      if column_names.nil?
        idx.to_s
      else
        column_names[idx].to_s
      end
    end
  end
end
