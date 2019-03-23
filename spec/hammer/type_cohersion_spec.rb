
include Hammer::TypeCohersable

RSpec.describe Hammer::TypeCohersable do
  context "#coherse" do
    it "coherse a valid integer" do
      expect(coherse("1", "int")).to eq 1
      expect(coherse("1.5", "int")).to eq 1
      expect(coherse("1", "int:strict")).to eq 1

      expect(coherse(1, "int")).to eq 1
      expect(coherse(1.5, "int")).to eq 1
      expect(coherse(1, "int:strict")).to eq 1
      expect(coherse(1.5, "int:strict")).to eq 1
    end

    it "cannot coherse an invalid integer" do
      expect{coherse("1.5", "int:strict")}.to raise_error ArgumentError
      expect{coherse("a", "int:strict")}.to raise_error ArgumentError
    end
  end
end

