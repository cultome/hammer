
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
      expect(translate_class_to_type(missing.class)).to eq "missing"
    end

    it "translate a nil" do
      expect(translate_class_to_type(NilClass)).to eq "missing"
    end

    it "translate a Date" do
      expect(translate_class_to_type(Date)).to eq "date"
    end

    it "translate a Datetime" do
      expect(translate_class_to_type(DateTime)).to eq "date_time"
    end

    it "translate a Time" do
      expect(translate_class_to_type(Time)).to eq "time"
    end
  end

  context "coherse an date" do
    it "a valid value" do
      expect(coherse("2018-12-31", "date|%Y-%m-%d")).to eq Date.strptime("2018-12-31")
    end
  end

  context "coherse an integer" do
    it "a valid value" do
      expect(coherse("1", "integer")).to eq 1
      expect(coherse("1.5", "integer")).to eq 1
      expect(coherse("20 años", "integer")).to eq 20
      expect(coherse("20 ", "integer")).to eq 20
      expect(coherse(" 20", "integer")).to eq 20
      expect(coherse(" 20 ", "integer")).to eq 20
      expect(coherse("otra 20", "integer")).to eq 20

      expect(coherse("1", "integer|strict")).to eq 1

      expect(coherse(1, "integer")).to eq 1
      expect(coherse(1.5, "integer")).to eq 1
      expect(coherse(1, "integer|strict")).to eq 1
      expect(coherse(1.5, "integer|strict")).to eq 1
    end

    it "an invalid value" do
      expect(coherse("1.5", "integer|strict")).to eq invalid
      expect(coherse("a", "integer|strict")).to eq invalid
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
      expect(coherse(nil, "string")).to eq missing
      expect(coherse(nil, "integer")).to eq missing
      expect(coherse(nil, "integer|strict")).to eq missing
    end
  end

  it "calculates the common denominator for a list of types" do
    expect(more_general_type(["integer", "integer"])).to eq "integer"
    expect(more_general_type(["missing", "missing"])).to eq "string"
    expect(more_general_type(["missing", "date_time"])).to eq "date_time"
    expect(more_general_type(["integer", "float"])).to eq "float"
    expect(more_general_type(["time", "date"])).to eq "date_time"
    expect(more_general_type(["date", "float"])).to eq "string"
    expect(more_general_type(["date", "float", "missing"])).to eq "string"
    expect(more_general_type(["integer", "float", "missing"])).to eq "float"
  end

  it "detect value format" do
    expect(detect_type("1234")).to eq "integer"
    expect(detect_type("123.45")).to eq "float"
    expect(detect_type("02-10-1990")).to eq "date|%d-%m-%Y"
    expect(detect_type("1983/10/28")).to eq "date|%Y/%m/%d"
    expect(detect_type("23:45")).to eq "time"
    expect(detect_type("2010-03-01 12:59")).to eq "date_time|%Y-%m-%d %H:%M"
    expect(detect_type("2010/03/01 12:59:30")).to eq "date_time|%Y/%m/%d %H:%M:%S"
    expect(detect_type("01-03-2010T12:59")).to eq "date_time|%d-%m-%YT%H:%M"
    expect(detect_type("01/03/2010T12:59:30")).to eq "date_time|%d/%m/%YT%H:%M:%S"
    expect(detect_type("123something")).to eq "string"
    expect(detect_type("")).to eq "missing"
    expect(detect_type(nil)).to eq "missing"
  end

  it "tries to coherese invalid values"
end
