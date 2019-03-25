
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
      expect(data.columns.values.map{|c| c[:type]}).to eq ["string", "int", "date"]
    end

    it "the dataframe has the correct column names" do
      expect(data.columns.values.map{|c| c[:name]}).to eq ["name", "age", "join"]
    end
  end
end
