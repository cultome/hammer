module Hammer::Structure
  class Missing
    def ==(obj)
      obj.is_a? Missing
    end
  end
end
