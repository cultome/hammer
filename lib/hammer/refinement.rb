
module Hammer::Refinement
  refine Symbol do
    def titlecase
      self
        .to_s
        .downcase
        .split("_")
        .map{|w| "#{w[0].upcase}#{w[1..]}"}
        .join(" ")
    end
  end
end

