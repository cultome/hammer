module Hammer
  module CLI
    using Rainbow
    using Hammer::Refinement

    def inspect(file)
      dataframe, file_format = detect_and_load file

      print_property "File format", file_format
      print_property("Number of records", dataframe.size) if extras.fetch("fullload", false)
      dataframe.metadata.each{|k,v| print_property(k.titlecase, v)}
      print_property "Properties", dataframe.columns.map{|p| "\n  - #{p.name} (#{p.type.to_s.yellow})"}.join

      print_stats dataframe if options[:stats]
      print_sample dataframe if options[:sample]
    end

    def template(file, template_string)
      dataframe, _ = detect_and_load file

      template = ERB.new template_string
      names = dataframe.column_names.map(&:downcase).map{|name| name.gsub(/[\s]/, "_")}.map(&:to_sym)
      dataframe.rows.each do |row|
        ctx = Hash[names.zip(row)]
        output.puts template.result_with_hash(ctx)
      end
    end

    private

    def print_sample(dataframe)
      print_property "Content sample"
      dataframe.rows.take(5).each do |row|
        output.puts row.join(" | ".yellow)
      end
    end

    def print_stats(dataframe)
      stats = dataframe.columns.each_with_object([]) do |col,acc|
        stat = col.stats

        unless stat.nil?
          acc << "  #{col.name} (#{col.type.to_s.yellow})"
          stat.each do |(k,v)|
            acc << "    - #{k}: #{v.to_s.cyan}"
          end
        end
      end

      print_property "Stats", "\n" + stats.join("\n") unless stats.empty?
    end

    def output
      @output ||= options[:output].nil? ? STDOUT : open(options[:output], "w")
    end

    def detect_and_load(file)
      file_format = detect_format(file, extras: extras)
      dataframe = loads(file_format, filename: file, extras: extras)

      [dataframe, file_format]
    end

    def extras
      @extras ||= options[:extras].merge("fullload" => options[:fullload])
    end

    def print_property(prop, value="")
      output.puts "#{prop.red}: #{value.to_s}"
    end
  end
end
