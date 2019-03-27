module Hammer::Type
  def missing
    @@missing ||= Missing.new
  end

  private

  class Missing
    def nil?
      true
    end

    def inspect
      to_s
    end

    def to_s
      "missing"
    end
  end
end
