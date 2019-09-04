
RSpec.describe Hammer::Loader::CSV do
  context "loads a csv file" do
    let(:data){loads(:csv, filename: "spec/data/example_1.csv")}

    it "returns a dataframe" do
      expect(data).to be_instance_of Dataframe
    end

    it "the dataframe contains all the rows" do
      expect(data.size).to eq 6
    end

    it "the dataframe has the correct column type" do
      expect(data.all_columns.map{|c| c.type.name}).to eq ["string", "integer", "date"]
    end

    it "the dataframe has the correct column names" do
      expect(data.all_columns.map{|c| c.name}).to eq ["name", "age", "join"]
    end
  end
end
