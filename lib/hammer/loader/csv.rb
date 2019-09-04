module Hammer
  module Loader
    module CSV
      include Hammer::TypeCohersable

      using Hammer::Refinement

      def load_csv(filename, extras: {})
        options = csv_extras_defaults.merge(extras)

        data, headers = parse_csv_content(filename, extras: options)

        build_dataframe(data: data, column_names: headers)
      end

      private

      def csv_extras_defaults
        {
          "fullload" => false,
          "load_only" => 10,
        }
      end

      def parse_csv_content(filename, extras: {})
        data = load_csv_file(filename, extras)
        headers = csv_headers(data)
        content = data.map(&:coherse_values)

        [content, headers]
      end

      def csv_headers(data)
        header_types = data.first.map{|v| detect_type(v)}
        first_row_types = data[1].map{|v| detect_type(v)}

        header_types.map(&:name) != first_row_types.map(&:name) ? data.shift : nil
      end

      def load_csv_file(filename, extras, try_again = true, options = {encoding: "UTF-8"})
        csv = ::CSV.open(filename, **options)

        if extras.fetch("fullload", true)
          csv.readlines
        else
          csv.take(extras.fetch("load_only", 10))
        end
      rescue ::CSV::MalformedCSVError => error
        raise error unless try_again

        puts "[*] Problems with encoding! trying to convert to UTF-8 from latin"
        load_csv_file(filename, extras, false, {encoding: "ISO-8859-1"})
      end
    end
  end
end
