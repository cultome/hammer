
module Hammer::Structure
  class Vector
    attr_reader :name

    def initialize(data: [], name: "0")
      @data = data
      @name = name
    end
  end
end
