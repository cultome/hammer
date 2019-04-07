require "forwardable"
require "set"
require "hammer/statisticable"

module Hammer::Structure
  class Vector
    extend Forwardable

    include Hammer::TypeCohersable
    include Hammer::Statisticable

    attr_reader :data
    attr_reader :name
    attr_reader :type

    def_delegators :@data, :size, :each, :[]

    def initialize(data: [], name: "0", type: nil)
      if type.nil?
        @data = data

        types = data.each_with_object(Set.new){|val,acc| acc.add(translate_class_to_type(val.class))}
        @type = more_general_type(types)
      else
        @data = data.map{|e| coherse(e, type) }
        @type, _ = type.split("|")
      end

      @name = name.to_s
    end

    def push(value:, value_type:)
      data.push(coherse(value, value_type))

      new_type = more_general_type([value_type, type])
      if new_type != type
        puts "Change of vector type from [#{type}] to the more general [#{new_type}]"

        @type = new_type
        @data = data.map{|v| coherse(v, new_type)}
      end
    end

    def fetch(*idxs)
      data.filter.with_index{|v,idx| idxs.include?(idx) }
    end
  end # class Vector
end
