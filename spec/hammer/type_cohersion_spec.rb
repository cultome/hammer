
include Hammer::TypeCohersable

RSpec.describe Hammer::TypeCohersable do
  context "translate classes into types" do
    it "translate a Integer" do
      expect(translate_class_to_type(Integer).name).to eq "integer"
    end

    it "translate a String" do
      expect(translate_class_to_type(String).name).to eq "string"
    end

    it "translate a Float" do
      expect(translate_class_to_type(Float).name).to eq "float"
    end

    it "translate a Missing" do
      expect(translate_class_to_type(missing.class).name).to eq "missing"
    end

    it "translate a nil" do
      expect(translate_class_to_type(NilClass).name).to eq "missing"
    end

    it "translate a Date" do
      expect(translate_class_to_type(Date).name).to eq "date"
    end

    it "translate a Datetime" do
      expect(translate_class_to_type(DateTime).name).to eq "date_time"
    end

    it "translate a Time" do
      expect(translate_class_to_type(Time).name).to eq "time"
    end
  end

  context "coherse an date" do
    it "a valid value" do
      expect(coherse("2018-12-31", data_type(name: "date", format: "%Y-%m-%d"))).to eq Date.strptime("2018-12-31")
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

      expect(coherse("1", data_type(name: "integer", strict: true))).to eq 1

      expect(coherse(1, "integer")).to eq 1
      expect(coherse(1.5, "integer")).to eq 1
      expect(coherse(1, data_type(name: "integer", strict: true))).to eq 1
      expect(coherse(1.5, data_type(name: "integer", strict: true))).to eq 1
    end

    it "an invalid value" do
      expect(coherse("1.5", data_type(name: "integer", strict: true))).to eq invalid
      expect(coherse("a", "dogtype")).to eq invalid
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
      expect(coherse(nil, data_type(name: "integer", strict: true))).to eq missing
    end
  end

  it "calculates the common denominator for a list of types" do
    expect(more_general_type(["integer", "integer"]).name).to eq "integer"
    expect(more_general_type(["missing", "missing"]).name).to eq "string"
    expect(more_general_type(["missing", "date_time"]).name).to eq "date_time"
    expect(more_general_type(["integer", "float"]).name).to eq "float"
    expect(more_general_type(["time", "date"]).name).to eq "date_time"
    expect(more_general_type(["date", "float"]).name).to eq "string"
    expect(more_general_type(["date", "float", "missing"]).name).to eq "string"
    expect(more_general_type(["integer", "float", "missing"]).name).to eq "float"
  end

  it "detect value format" do
    expect(detect_type("1234").name).to eq "integer"
    expect(detect_type("123.45").name).to eq "float"

    expect(detect_type("02-10-1990").name).to eq "date"
    expect(detect_type("02-10-1990").format).to eq "%d-%m-%Y"

    expect(detect_type("1983/10/28").name).to eq "date"
    expect(detect_type("1983/10/28").format).to eq "%Y/%m/%d"

    expect(detect_type("23:45").name).to eq "time"

    expect(detect_type("2010-03-01 12:59").name).to eq "date_time"
    expect(detect_type("2010-03-01 12:59").format).to eq "%Y-%m-%d %H:%M"

    expect(detect_type("2010/03/01 12:59:30").name).to eq "date_time"
    expect(detect_type("2010/03/01 12:59:30").format).to eq "%Y/%m/%d %H:%M:%S"

    expect(detect_type("01-03-2010T12:59").name).to eq "date_time"
    expect(detect_type("01-03-2010T12:59").format).to eq "%d-%m-%YT%H:%M"

    expect(detect_type("01/03/2010T12:59:30").name).to eq "date_time"
    expect(detect_type("01/03/2010T12:59:30").format).to eq "%d/%m/%YT%H:%M:%S"

    expect(detect_type("123something").name).to eq "string"
    expect(detect_type("").name).to eq "missing"
    expect(detect_type(nil).name).to eq "missing"
  end

  it "tries to coherese invalid values"
end
