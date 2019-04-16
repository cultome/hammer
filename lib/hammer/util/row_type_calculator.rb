module Hammer::Util
  class RowTypeCalculator
    def add(row_types)
      check_allocation(row_types.size)

      row_types.each_with_index do |type,idx|
        if cols[idx].nil?
        require "pry";binding.pry
        end
        cols[idx][type.serialize] += 1
      end
    end

    def detected_types
      cols
        .map{|col|
          col.max{|a,b| a[1] <=> b[1]}.first
        }.map{|serialized_type|
          name, format, strict = serialized_type.split("~>")
          data_type(name: name, format: format, strict: strict)
        }
    end

    private

    def check_allocation(col_count)
      return cols if cols.size >= col_count

      (col_count - cols.size).times do
        cols.push(Hash.new{|h,k| h[k] = 0})
      end
    end

    def cols
      @cols ||= []
    end
  end
end
