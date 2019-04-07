require "date"

module Hammer::TypeCohersable
  include Hammer::Type

  def coherse(value, dest_type)
    return missing if value.nil? || value.to_s.empty?

    dest_type = data_type(name: dest_type) if dest_type.is_a? String

    raise "unable to coherse type #{dest_type.name}" unless respond_to?("coherse_#{dest_type.name}", true)

    send("coherse_#{dest_type.name}", value, dest_type)
  rescue Exception
    return invalid
  end

  def translate_class_to_type(clazz)
    internal_type = clazz.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase

    return data_type(name: "missing") if internal_type == "nil_class"

    type_name = internal_type.split("::").last
    data_type(name: type_name)
  end

  def more_general_type(types)
    types
      .map{|t| t.is_a?(String) ? data_type(name: t) : t}
      .reduce{|t1,t2| common_super_type(t1,t2)}
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
      classes.include?(t1.name) && classes.include?(t2.name)
    end

    return data_type(name: "string") if super_type.nil?

    data_type(name: super_type)
  end

  private

  def coherse_date(value, type)
    return value if value.is_a? Date

    Date.strptime(value, type.format)
  rescue
    invalid
  end

  def coherse_time(value, type)
    return value if value.is_a? DateTime

    DateTime.strptime(value, type.format)
  rescue
    invalid
  end

  def coherse_date_time(value, type)
    return value if value.is_a? DateTime

    DateTime.strptime(value, type.format)
  rescue
    invalid
  end

  def coherse_string(value, type)
    value.to_s
  end

  def coherse_integer(value, type)
    return value if value.is_a? Integer

    if type.strict?
      coherse_strict_integer(value, type)
    else
      coherse_relaxed_integer(value, type)
    end
  end

  def coherse_float(value, type)
    return value if value.is_a? Float

    Float(value)
  end

  def coherse_strict_integer(value, type)
    Integer(value)
  end

  def coherse_relaxed_integer(value, type)
    value.to_s.gsub(/[^0-9.]/, "").to_i
  end
end
