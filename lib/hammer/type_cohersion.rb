require "date"

module Hammer::TypeCohersable
  def coherse(value, dest_type)
    return Missing.new if value.nil? || value.is_a?(Missing)

    type, args_exp = dest_type.split(":")
    args = args_exp&.split(",") || []

    case type
    when "integer"
      coherse_int(value, args)
    when "string"
      coherse_string(value, args)
    when "date"
      coherse_date(value, args)
    when "float"
      coherse_float(value, args)
    when "date_time"
      coherse_datetime(value, args)
    when "time"
      coherse_time(value, args)
    end
  end

  def translate_class_to_type(clazz)
    if clazz == Integer
      "integer"
    elsif clazz == Date
      "date"
    elsif clazz == String
      "string"
    elsif clazz == Float
      "float"
    elsif clazz == DateTime
      "date_time"
    elsif clazz == Time
      "time"
    elsif clazz == Missing || clazz == NilClass
      "missing"
    else
      raise "invalid column type #{clazz}"
    end
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

  def coherse_datetime(value, args)
    return value if value.is_a? DateTime

    DateTime.strptime(value, args)
  end

  def coherse_string(value, args)
    value.to_s
  end

  def coherse_int(value, args)
    return value if value.is_a? Integer

    if args.delete("strict").nil?
      coherse_relaxed_int(value, args)
    else
      coherse_strict_int(value, args)
    end
  end

  def coherse_float(value, args)
    return value if value.is_a? Float

    Float(value)
  end

  def coherse_strict_int(value, args)
    Integer(value)
  end

  def coherse_relaxed_int(value, args)
    value.to_i
  end
end
