
include Hammer::TypeCohersable

RSpec.describe Hammer::TypeCohersable do
  context "translate classes into types" do
    it "translate a Integer" do
      expect(translate_class_to_type(Integer)).to eq "integer"
    end

    it "translate a String" do
      expect(translate_class_to_type(String)).to eq "string"
    end

    it "translate a Float" do
      expect(translate_class_to_type(Float)).to eq "float"
    end

    it "translate a Missing" do
      expect(translate_class_to_type(Missing)).to eq "missing"
    end

    it "translate a Date" do
      expect(translate_class_to_type(Missing)).to eq "missing"
    end

    it "translate a Datetime" do
      expect(translate_class_to_type(DateTime)).to eq "date_time"
    end

    it "translate a Time" do
      expect(translate_class_to_type(Time)).to eq "time"
    end
  end

  context "coherse an integer" do
    it "a valid value" do
      expect(coherse("1", "integer")).to eq 1
      expect(coherse("1.5", "integer")).to eq 1
      expect(coherse("1", "integer:strict")).to eq 1

      expect(coherse(1, "integer")).to eq 1
      expect(coherse(1.5, "integer")).to eq 1
      expect(coherse(1, "integer:strict")).to eq 1
      expect(coherse(1.5, "integer:strict")).to eq 1
    end

    it "an invalid value" do
      expect{coherse("1.5", "integer:strict")}.to raise_error ArgumentError
      expect{coherse("a", "integer:strict")}.to raise_error ArgumentError
    end
  end

  context "coherse a string" do
    it "any value" do
      expect(coherse("uno", "string")).to eq "uno"
      expect(coherse(1, "string")).to eq "1"
      expect(coherse(1.5, "string")).to eq "1.5"
    end
  end

  context "coherse a nil" do
    it "any value should return missing" do
      expect(coherse(nil, "string")).to eq Missing.new
      expect(coherse(nil, "integer")).to eq Missing.new
      expect(coherse(nil, "integer:strict")).to eq Missing.new
    end
  end

  it "#more_general_type"
  it "#detect_type_and_cast"
end
