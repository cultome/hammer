
module Hammer::TypeCohersable
  def coherse(value, dest_type)
    return value if value.is_a? Missing

    type, args = dest_type.split(":")
    case type
    when "int"
      coherse_int(value, args)
    when "string"
      coherse_string(value, args)
    end
  end

  def translate_class_to_type(clazz)
    if clazz == Integer
      "int"
    elsif clazz == String
      "string"
    elsif clazz == Missing
      "missing"
    else
      raise "invalid column type #{clazz}"
    end
  end

  private

  def coherse_string(value, args)
    value.to_s
  end

  def coherse_int(value, arg_exp)
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
