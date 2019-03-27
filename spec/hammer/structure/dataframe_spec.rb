
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

      it "should report column type" do
        expect(d.get("0").type).to eq "string"
        expect(d.get("1").type).to eq "integer"
        expect(d.get("2").type).to eq "string"
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
    end # with a multi-dimensional array

    context "with a multi-dimensional array and column names" do
      let(:d){
        Dataframe.new(
          data: [
            ["Carlos Estevez",35,"30-06-1985"],
            ["Romero Alvarado",12,"02-10-1990"],
            ["Saul Estevez",9,"01-03-2010"],
            [Missing.new,10,"01-02-2003"],
            ["Erin Raimer",Missing.new,"01-01-2019"],
            ["Sacha Petricor",5,Missing.new],
          ],
          column_names: [
            "name",
            "age",
            "birthday",
          ]
        )
      }

      it "should report correct column names"
    end

    context "with a multi-dimensional array, column names and column type" do
      let(:d){
        Dataframe.new(
          data: [
            ["Carlos Estevez",35,"30-06-1985"],
            ["Romero Alvarado",12,"02-10-1990"],
            ["Saul Estevez",9,"01-03-2010"],
            [Missing.new,10,"01-02-2003"],
            ["Erin Raimer",Missing.new,"01-01-2019"],
            ["Sacha Petricor",5,Missing.new],
          ],
          column_names: [
            "name",
            "age",
            "birthday",
          ],
          column_types: [
            String,
            Integer,
            Date,
          ]
        )
      }

      it "should report correct column types"
    end
  end # initialize a dataframe

  context "with a valid dataframe" do
    it "gets a dataframe with selected columns"
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
