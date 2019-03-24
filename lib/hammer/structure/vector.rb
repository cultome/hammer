require "forwardable"
require "set"

module Hammer::Structure
  class Vector
    extend Forwardable

    include Hammer::TypeCohersable

    attr_reader :data
    attr_reader :name
    attr_reader :types

    def_delegators :@data, :size, :each

    def initialize(data: [], name: "0", type: nil)
      if type.nil?
        @data = data
        @types = data.each_with_object(Set.new){|val,acc| acc.add(translate_class_to_type(val.class))}
      else
        @data = data.map{|e| coherse(e, type) }
        @types = Set.new([type])
      end

      @name = name
    end

    def push(data:, type:)
      @data.push(coherse(data, type))
      @types.add(type)
    end
  end # class Vector
end
