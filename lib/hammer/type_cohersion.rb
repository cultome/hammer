require "date"

module Hammer::TypeCohersable
  include Hammer::Type

  def coherse(value, dest_type)
    return missing if value.nil? || value.to_s.empty?

    type, args_exp = dest_type.split("|")
    args = args_exp&.split(",") || []

    raise "unable to coherse type #{type}" unless respond_to?("coherse_#{type}", true)

    send("coherse_#{type}", value, args)
  rescue Exception
    return invalid
  end

  def translate_class_to_type(clazz)
    internal_type = clazz.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase

    return "missing" if internal_type == "nil_class"

    internal_type.split("::").last
  end

  def more_general_type(types)
    types.reduce{|t1,t2| common_super_type(t1,t2)}
  end

  def common_super_type(t1, t2)
    super_type, _ = [
      ["string", ["missing", "string"]],
      ["float", ["missing", "float"]],
      ["integer", ["missing", "integer"]],
      ["date_time", ["missing", "date_time"]],
      ["date", ["missing", "date"]],
      ["time", ["missing", "time"]],

      ["float", ["integer", "float"]],

      ["date_time", ["date", "time", "date_time"]],

      ["string", ["float", "string"]],
      ["string", ["integer", "string"]],
      ["string", ["date_time", "string"]],
      ["string", ["date", "string"]],
      ["string", ["time", "string"]],
    ].find do |(_, classes)|
      classes.include?(t1) && classes.include?(t2)
    end

    super_type.nil? ? "string" : super_type
  end

  private

  def coherse_date(value, args)
    return value if value.is_a? Date

    Date.strptime(value, args.first)
  rescue
    invalid
  end

  def coherse_time(value, args)
    return value if value.is_a? DateTime

    DateTime.strptime(value, args)
  rescue
    invalid
  end

  def coherse_date_time(value, args)
    return value if value.is_a? DateTime

    DateTime.strptime(value, args.first)
  rescue
    invalid
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
    value.to_s.gsub(/[^0-9.]/, "").to_i
  end
end
