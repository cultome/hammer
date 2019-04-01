
module Hammer::Refinement
  include Hammer::TypeCohersable

  refine Array do
    def coherse_values
      map do |value|
        type = detect_type(value)
        coherse(value, type)
      end
    end
  end

  refine Symbol do
    def titlecase
      to_s
        .downcase
        .split("_")
        .map{|w| "#{w[0].upcase}#{w[1..]}"}
        .join(" ")
    end
  end
end

