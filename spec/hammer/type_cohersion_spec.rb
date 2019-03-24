
include Hammer::TypeCohersable

RSpec.describe Hammer::TypeCohersable do
  context "translate classes into types" do
    it "translate a Integer" do
      expect(translate_class_to_type(Integer)).to eq "int"
    end

    it "translate a String" do
      expect(translate_class_to_type(String)).to eq "string"
    end

    it "translate a Missing" do
      expect(translate_class_to_type(Missing)).to eq "missing"
    end

    it "translate a not supported class" do
      expect{translate_class_to_type(Set)}.to raise_error "invalid column type Set"
    end
  end

  context "coherse an integer" do
    it "a valid value" do
      expect(coherse("1", "int")).to eq 1
      expect(coherse("1.5", "int")).to eq 1
      expect(coherse("1", "int:strict")).to eq 1

      expect(coherse(1, "int")).to eq 1
      expect(coherse(1.5, "int")).to eq 1
      expect(coherse(1, "int:strict")).to eq 1
      expect(coherse(1.5, "int:strict")).to eq 1
    end

    it "an invalid value" do
      expect{coherse("1.5", "int:strict")}.to raise_error ArgumentError
      expect{coherse("a", "int:strict")}.to raise_error ArgumentError
    end
  end

  context "coherse a string" do
    it "any value" do
      expect(coherse("uno", "string")).to eq "uno"
      expect(coherse(1, "string")).to eq "1"
      expect(coherse(1.5, "string")).to eq "1.5"
    end
  end
end

