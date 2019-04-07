
module Hammer::Detector
  def detect_format(filename, extras: {})
    fragment = File.new(filename).read(100)

    detector_methods = private_methods.grep(/^is_(\w+?)_format\?$/)
    format = detector_methods.find{|mtd| send(mtd, fragment) }

    raise "unrecognized format" if format.nil?

    format =~ /^is_(\w+?)_format\?$/ && $1.to_sym
  end

  def detect_type(value)
    return "missing" if value.nil? || (value.respond_to?(:empty?) && value.empty?)

    case value
    when /^-?[\d]+$/ then "integer"
    when /^-?[\d]+\.[\d]+$/ then "float"

    when /^[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "time"

    when /^[\d]{1,2}(.)[\d]{1,2}(.)[\d]{4}$/ then "date|%d#{$1}%m#{$2}%Y"
    when /^[\d]{4}(.)[\d]{1,2}(.)[\d]{1,2}$/ then "date|%Y#{$1}%m#{$2}%d"

    when /^[\d]{1,2}(.)[\d]{1,2}(.)[\d]{4}([\D]+)[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "date_time|%d#{$1}%m#{$2}%Y#{$3}%H:%M#{$4.nil? ? "" : ":%S"}"
    when /^[\d]{4}(.)[\d]{1,2}(.)[\d]{1,2}([\D]+)[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "date_time|%Y#{$1}%m#{$2}%d#{$3}%H:%M#{$4.nil? ? "" : ":%S"}"

    when /^[\d]{4}(.)[\d]{2}(.)[\d]{2}([\D]+)[\d]{2}:[\d]{2}:[\d]{2}[\-+][\d]{2}:[\d]{2}$/ then "date_time|%Y#{$1}%m#{$2}%d#{$3}%H:%M:%S%z"

    else "string"
    end
  end

  private

  def is_csv_format?(fragment)
    fragment.start_with?(/[\w"']/) && fragment.count(",") > 1
  end

  def is_xlsx_format?(fragment)
    fragment.include?("[Content_Types].xml")
  end
end
