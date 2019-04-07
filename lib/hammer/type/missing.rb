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
      "missing"
    end

    def to_s
      ""
    end

    def method_missing(mtd, *args)
      nil
    end
  end
end
