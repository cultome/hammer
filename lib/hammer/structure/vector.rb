require "forwardable"

module Hammer::Structure
  class Vector
    extend Forwardable

    attr_reader :name
    attr_reader :type

    def_delegators :@data, :size, :each

    def initialize(data: [], name: "0", type: nil)
      if type.nil?
        @data = data
      else
        @data = data.map{|e| coherse(e, type) }
      end

      @name = name
      @type = type
    end
  end
end
