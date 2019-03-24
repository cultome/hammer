=begin
df = Dataframe.new([
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

RSpec.describe Hammer::Structure::Dataframe do
  context "initialize a dataframe" do
    context "with a multi-dimensional array" do
      let(:d){
        Dataframe.new(data: [
          ["Carlos Estevez",35,"30-06-1985"],
          ["Romero Alvarado",12,"02-10-1990"],
          ["Saul Estevez",9,"01-03-2010"],
          [Missing.new,10,"01-02-2003"],
          ["Erin Raimer",Missing.new,"01-01-2019"],
          ["Sacha Petricor",5,Missing.new],
        ])
      }

      it "should report columns count" do
        expect(d.columns.size).to eq 3
      end

      it "should report column types" do
        expect(d.columns["0"][:types].to_a).to eq ["string", "missing"]
        expect(d.columns["1"][:types].to_a).to eq ["int", "missing"]
        expect(d.columns["2"][:types].to_a).to eq ["string", "missing"]
      end

      it "should get columns by name" do
        expect(d.get("0")).to be_a Vector
      end

      it "should get correct columns values" do
        expect(d.get("0").data).to eq [
          "Carlos Estevez",
          "Romero Alvarado",
          "Saul Estevez",
          Missing.new,
          "Erin Raimer",
          "Sacha Petricor",
        ]
      end
    end
  end

  it "initialize a dataframe with an array of vectors"
  it "initialize a dataframe with a hash"
  it "initialize a dataframe with column names"
  it "initialize a dataframe with column types"
  it "initialize a dataframe with row names"
  it "initialize a dataframe with data of different shapes"
  it "initialize a dataframe with data of different shapes and column names"

  it "selects a single column by name"
  it "selects a single column by index"
  it "selects a single row by name"
  it "selects a single row by index"

  it "selects a slice of columns by name"
  it "selects a slice of columns by index"
  it "selects a slice of rows by name"
  it "selects a slice of rows by index"

  it "deletes a row by name"
  it "deletes a row by index"
  it "deletes a column by name"
  it "deletes a column by index"

  it "sums two columns"
end
