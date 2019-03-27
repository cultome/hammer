module Hammer::Type
  def missing
    @@missing ||= Missing.new
  end

  private

  class Missing
    def nil?
      true
    end
  end
end
