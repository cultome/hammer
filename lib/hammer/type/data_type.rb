
module Hammer::Type
  def data_type(name:, format: nil, strict: false)
    DataType.new(name, format, strict)
  end

  private

  class DataType
    attr_reader :name
    attr_reader :format

    def initialize(name, format, strict)
      @name = name
      @format = format || ""
      @strict = strict
    end

    def strict?
      @strict
    end

    def serialize
      "#{@name}~>#{@format}~>#{@strict}"
    end

    def to_s
      "#{@name}#{@format.empty? ? '' : " [#{@format}]"}#{@strict ? ' strict' : ''}"
    end
  end
end
