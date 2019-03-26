require "date"

module Hammer::TypeCohersable

  def coherse(value, dest_type)
    return Missing.new if value.nil? || value.is_a?(Missing)

    type, args_exp = dest_type.split(":")
    args = args_exp&.split(",") || []

    raise "unable to coherse type #{type}" unless respond_to?("coherse_#{type}", true)

    send("coherse_#{type}", value, args)
  end

  def translate_class_to_type(clazz)
    internal_type = clazz.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase

    return "missing" if internal_type == "nil_class"

    internal_type.split("::").last
  end

  def more_general_type(types)
    ordered_types = [
      "string",
      "float",
      "integer",
      "date",
      "time",
      "date_time",
      "missing",
    ]

    types.min{|a,b| ordered_types.index(a) <=> ordered_types.index(b)}
  end

  def detect_type(value)
    return "missing" if value.nil?

    case value
    when /^[\d]+$/ then "integer"
    when /^[\d]+.[\d]+$/ then "float"
    when /^[\d]{2}(.)[\d]{2}(.)[\d]{4}$/ then "date:%d#{$1}%m#{$2}%Y"
    when /^[\d]{4}(.)[\d]{2}(.)[\d]{2}$/ then "date:%Y#{$1}%m#{$2}%d"
    when /^[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "time"
    when /^[\d]{2}(.)[\d]{2}(.)[\d]{4}([.+?])[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "date_time"
    when /^[\d]{4}(.)[\d]{2}(.)[\d]{2}([.+?])[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "date_time"
    else "string"
    end
  end

  private

  def coherse_date(value, args)
    return value if value.is_a? Date

    Date.strptime(value, args.first)
  end

  def coherse_time(value, args)
    return value if value.is_a? DateTime

    DateTime.strptime(value, args)
  end

  def coherse_date_time(value, args)
    return value if value.is_a? DateTime

    DateTime.strptime(value, args)
  end

  def coherse_string(value, args)
    value.to_s
  end

  def coherse_integer(value, args)
    return value if value.is_a? Integer

    if args.delete("strict").nil?
      coherse_relaxed_integer(value, args)
    else
      coherse_strict_integer(value, args)
    end
  end

  def coherse_float(value, args)
    return value if value.is_a? Float

    Float(value)
  end

  def coherse_strict_integer(value, args)
    Integer(value)
  end

  def coherse_relaxed_integer(value, args)
    value.to_i
  end
end
