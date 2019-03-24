require "set"

module Hammer::Structure
  class Dataframe
    include Hammer::TypeCohersable

    attr_reader :columns

    def initialize(data: [], column_names: nil, column_types: nil)
      @vectors = {}
      @columns = {}

      data.each_with_index do |row,ridx|
        row.each_with_index do |col_value,cidx|
          col_name = column_name(column_names, cidx)
          col_type = column_type(column_types, cidx, col_value)

          if @columns.has_key? col_name
            @columns[col_name][:types].add(col_type)
          else
            @columns[col_name] = {name: col_name, types: Set.new([col_type])}
          end

          if @vectors.has_key? col_name
            #require "pry";binding.pry
            @vectors[col_name].push(data: col_value, type: col_type)
          else
            #require "pry";binding.pry
            @vectors[col_name] = Vector.new(data: [col_value], name: col_name, type: col_type)
          end
        end
      end
    end

    def get(column_name)
      @vectors.fetch(column_name)
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
