module Hammer
  module Structure
    def build_dataframe(**args)
      Dataframe.new(**args)
    end

    class Dataframe
      include Hammer::TypeCohersable

      attr_reader :metadata

      def initialize(data: [], column_names: nil, column_types: nil, vectors: nil, metadata: {})
        if vectors.nil?
          from_raw_data(data: data, column_names: column_names, column_types: column_types, metadata: metadata)
        else
          @metadata = metadata
          @vectors = vectors
        end
      end

      def from_raw_data(data: [], column_names: nil, column_types: nil, metadata: {})
        @metadata = metadata
        @vectors = {}

        data.each_with_index do |this_row, ridx|
          this_row.each_with_index do |col_value, cidx|
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

      def pluck(*names)
        vectors = all_columns.
          select { |col| names.include? col.name }.
          each_with_object({}) { |col, acc| acc[col.name] = col }

        self.class.new(vectors: vectors)
      end

      def column(column_name)
        @vectors.fetch(column_name)
      end

      def row(idx)
        @vectors.values.map { |v| v[idx] }
      end

      def [](idx)
        row(idx)
      end

      def size
        if @vectors.first.nil?
          0
        else
          @vectors.first.last.size
        end
      end

      def all_columns
        @vectors.values
      end

      def column_names
        @vectors.keys
      end

      def rows
        Enumerator.new do |y|
          0.upto(@vectors.values.first.size - 1) do |idx|
            this_row = row(idx)
            y << this_row
          end
        end
      end

      def format(template_string)
        template = ERB.new template_string

        names = column_names.map(&:downcase).map { |name| name.gsub(/[\s]/, "_") }.map(&:to_sym)

        rows.map do |row|
          ctx = Hash[names.zip(row)]
          template.result_with_hash(ctx)
        end.join("\n")
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
        name = if column_names.nil?
                 idx.to_s
               else
                 column_names[idx].to_s
               end

        name == '' ? '_noname_' : name.tr('áéíóúÁÉÍÓÚ', 'aeiouAEIOU').gsub(/[\W]+/, '_')
      end
    end
  end
end
