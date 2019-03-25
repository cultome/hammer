require "date"

module Hammer::TypeCohersable
  def coherse(value, dest_type)
    return Missing.new if value.nil? || value.is_a?(Missing)

    type, args = dest_type.split(":")
    case type
    when "int"
      coherse_int(value, args)
    when "string"
      coherse_string(value, args)
    when "date"
      coherse_date(value, args)
    when "float"
      raise "implement cast to float"
    when "time"
      raise "implement cast to time"
    end
  end

  def translate_class_to_type(clazz)
    if clazz == Integer
      "int"
    elsif clazz == Date
      "date"
    elsif clazz == String
      "string"
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
      "int",
      "date",
      "missing",
    ]

    types.min{|a,b| ordered_types.index(a) <=> ordered_types.index(b)}
  end

  def detect_type(value)
    return "missing" if value.nil?

    case value
    when /^[\d]+$/ then "int"
    when /^[\d]+.[\d]+$/ then "float"
    when /^[\d]{2}(.)[\d]{2}(.)[\d]{4}$/ then "date:%d#{$1}%m#{$2}%Y"
    when /^[\d]{4}(.)[\d]{2}(.)[\d]{2}$/ then "date:%Y#{$1}%m#{$2}%d"
    when /^[\d]{1,2}:[\d]{1,2}(:[\d]{1,2})?$/ then "time"
    else "string"
    end
  end

  private

  def coherse_date(value, args)
    return value if value.is_a? Date

    Date.strptime(value, args)
  end

  def coherse_string(value, args)
    value.to_s
  end

  def coherse_int(value, arg_exp)
    return value if value.is_a? Integer

    args = arg_exp&.split(",") || []

    if args.delete("strict").nil?
      coherse_relaxed_int(value, args)
    else
      coherse_strict_int(value, args)
    end
  end

  def coherse_strict_int(value, args)
    Integer(value)
  end

  def coherse_relaxed_int(value, args)
    value.to_i
  end
end
