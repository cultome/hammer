
RSpec.describe Hammer::Structure::Dataframe do
  context "initialize a dataframe" do
    context "with a multi-dimensional array" do
      let(:d){
        Dataframe.new(data: [
          ["Carlos Estevez",35,"30-06-1985"],
          ["Romero Alvarado",12,"02-10-1990"],
          ["Saul Estevez",9,"01-03-2010"],
          [missing,10,"01-02-2003"],
          ["Erin Raimer",missing,"01-01-2019"],
          ["Sacha Petricor",5,missing],
        ])
      }

      it "should report columns count" do
        expect(d.all_columns.size).to eq 3
      end

      it "should report column type" do
        expect(d.column("0").type.name).to eq "string"
        expect(d.column("1").type.name).to eq "integer"
        expect(d.column("2").type.name).to eq "string"
      end

      it "should get column by name" do
        expect(d.column("0")).to be_a Vector
      end

      it "should get correct columns values" do
        expect(d.column("0").data).to eq [
          "Carlos Estevez",
          "Romero Alvarado",
          "Saul Estevez",
          missing,
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
            [missing,10,"01-02-2003"],
            ["Erin Raimer",missing,"01-01-2019"],
            ["Sacha Petricor",5,missing],
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
            [missing,10,"01-02-2003"],
            ["Erin Raimer",missing,"01-01-2019"],
            ["Sacha Petricor",5,missing],
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

    context "from another dataframe" do
      let(:d){
        Dataframe.new(
          data: [
            ["Carlos Estevez",35,"30-06-1985"],
            ["Romero Alvarado",12,"02-10-1990"],
            ["Saul Estevez",9,"01-03-2010"],
            [missing,10,"01-02-2003"],
            ["Erin Raimer",missing,"01-01-2019"],
            ["Sacha Petricor",5,missing],
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

      it "using pluck" do
        d2 = d.pluck("name", "age")

        expect(d2.column_names).to eq ["name", "age"]
      end
    end

    context "with metadata" do
      it "stores and extract metadata"
    end
  end # initialize a dataframe

  context "with a valid dataframe" do
    include Hammer::Loader

    let(:d){ loads(:csv, filename: "spec/data/example_1.csv") }

    it "iterates on rows" do
      count = 0
      d.rows.each{|row| count += 1 }
      expect(count).to eq 6
    end

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
