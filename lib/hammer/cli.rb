module Hammer
  module CLI
    using Rainbow
    using Hammer::Refinement

    def inspect(file)
      dataframe, file_format = detect_and_load file

      print_property "File format", file_format
      print_property("Number of records", dataframe.size) if extras.fetch("fullload", false)
      dataframe.metadata.each{|k,v| print_property(k.titlecase, v)}
      print_property "Properties", dataframe.all_columns.map{|p| "\n  - #{p.name} (#{p.type.to_s.yellow})"}.join

      print_stats dataframe if options[:stats]
      print_sample dataframe if options[:sample]
    end

    def template(template_string)
      dataframe, _ = detect_and_load options[:file]
      output.puts dataframe.format(template_string)
    end

    def plot(columns)
      dataframe, _ = detect_and_load(options["file"])
      template_string = columns.split(",").map{ |col| "<%= #{col} %>"}.join("\t")

      file = Tempfile.new("plot")
      file.write dataframe.format(template_string)

      Numo.gnuplot do
        define_singleton_method :refresh do
          plot "'#{file.path}'"
        end

        set :nokey
        refresh

        binding.pry
        # type exit to terminate
      end
    end

    def interactive
      dataframe, file_format = detect_and_load(options["file"]) unless options["file"].nil?
      clean_room = Hammer::CleanRoom.new(dataframe, file_format)

      Pry.start clean_room
    end

    private

    def print_sample(dataframe)
      print_property "Content sample"
      dataframe.rows.take(5).each do |row|
        output.puts row.join(" | ".yellow)
      end
    end

    def print_stats(dataframe)
      stats = dataframe.all_columns.each_with_object([]) do |col,acc|
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
