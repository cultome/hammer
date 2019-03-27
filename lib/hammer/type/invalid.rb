module Hammer::Type
  def invalid
    @@invalid ||= Invalid.new
  end

  private

  class Invalid
    def nil?
      true
    end

    def inspect
      to_s
    end

    def to_s
      "invalid"
    end
  end
end
