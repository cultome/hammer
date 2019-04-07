module Hammer::Util
  class RowTypeCalculator
    def add(row_types)
      check_allocation(row_types.size)

      row_types.each_with_index do |type,idx|
        @cols[idx][type.serialize] += 1
      end
    end

    def detected_types
      @cols
        .map do |col|
          col.max{|a,b| a[1] <=> b[1]}.first
        end
        .map do |serialized_type|
          name, format, strict = serialized_type.split("~>")
          data_type(name: name, format: format, strict: strict)
        end
    end

    private

    def check_allocation(col_count)
      @cols ||= Array.new(col_count){Hash.new{|h,k| h[k] = 0}}
    end
  end
end
