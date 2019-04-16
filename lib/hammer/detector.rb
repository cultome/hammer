
module Hammer::Detector
  def detect_format(filename, extras: {})
    fragment = File.new(filename).read(100)

    detector_methods = private_methods.grep(/^is_(\w+?)_format\?$/)
    format = detector_methods.find{|mtd| send(mtd, fragment) }

    raise "unrecognized format" if format.nil?

    format =~ /^is_(\w+?)_format\?$/ && $1.to_sym
  end

  def detect_type(value)
    return data_type(name: "missing") if value.nil? || (value.respond_to?(:empty?) && value.empty?)

    case value
    when /^-?[\d]+$/ then data_type(name: "integer")
    when /^-?[\d]+\.[\d]+$/ then data_type(name: "float")

    when /^[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then data_type(name: "time")

    when /^[\d]{1,2}(.)[\d]{1,2}(.)[\d]{4}$/ then data_type(name: "date", format: "%d#{$1}%m#{$2}%Y")
    when /^[\d]{4}(.)[\d]{1,2}(.)[\d]{1,2}$/ then data_type(name: "date", format: "%Y#{$1}%m#{$2}%d")

    when /^[\d]{1,2}(.)[\d]{1,2}(.)[\d]{4}([\D]+)[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then data_type(name: "date_time", format: "%d#{$1}%m#{$2}%Y#{$3}%H:%M#{$4.nil? ? "" : ":%S"}")
    when /^[\d]{4}(.)[\d]{1,2}(.)[\d]{1,2}([\D]+)[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then data_type(name: "date_time", format: "%Y#{$1}%m#{$2}%d#{$3}%H:%M#{$4.nil? ? "" : ":%S"}")

    when /^[\d]{4}(.)[\d]{2}(.)[\d]{2}([\D]+)[\d]{2}:[\d]{2}:[\d]{2}[\-+][\d]{2}:[\d]{2}$/ then data_type(name: "date_time", format: "%Y#{$1}%m#{$2}%d#{$3}%H:%M:%S%z")

    else data_type(name: "string")
    end
  end

  private

  def is_csv_format?(fragment)
    fragment.start_with?(/[\w"']/) && fragment.count(",") > 1
  end

  def is_xlsx_format?(fragment)
    fragment.include?("[Content_Types].xml") || fragment.include?("workbook.xml.rels")
  end
end
