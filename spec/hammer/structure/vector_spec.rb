=begin
  ["Carlos Estevez",35,"30-06-1985"],
  ["Romero Alvarado",12,"02-10-1990"],
  ["Saul Estevez",9,"01-03-2010"],
  [Missing.new,10,"01-02-2003"],
  ["Erin Raimer",Missing.new,"01-01-2019"],
  ["Sacha Petricor",5,Missing.new],
], [
  "name",
  "age",
  "birthday",
],
[
  String,
  Integer,
  Date,
])
=end

RSpec.describe Hammer::Structure::Vector do
  context "initialize a vector" do
    context "with a data array only" do
      let(:v){ Vector.new(data: [1,2,3,Missing.new,5]) }

      it "should report correct size" do
        expect(v.size).to eq 5
      end

      it "should have default name" do
        expect(v.name).to eq "0"
      end
    end

    context "with a data array and a name" do
      let(:v){ Vector.new(data: [1,2,3,Missing.new,5], name: "my column") }

      it "should read correct name" do
        expect(v.name).to eq "my column"
      end
    end

    context "with a data array, a name and a type" do
      let(:v){ Vector.new(data: [1,"2",3.5,Missing.new,5], name: "my mixed col", type: "int") }

      it "should convert item to the given type" do
        v.each{|e| expect([Integer, Missing]).to include(e.class) }
      end
    end

    it "initialize a vector with column type"
    it "initialize a vector with row name"

    it "selects a slice of rows by name"
    it "selects a slice of rows by index"

    it "deletes a row by name"
    it "deletes a row by index"

    it "sums two vectors"
  end
end
