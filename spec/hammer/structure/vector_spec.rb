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
  it "initialize a vector with an array" do
    v = Vector.new(data: ["Carlos Estevez",35,"30-06-1985"])
    expect(v.name).to eq "0"
  end

  it "initialize a vector with a hash"
  it "initialize a vector with column name"
  it "initialize a vector with column type"
  it "initialize a vector with row name"

  it "selects a slice of rows by name"
  it "selects a slice of rows by index"

  it "deletes a row by name"
  it "deletes a row by index"

  it "sums two vectors"
end
