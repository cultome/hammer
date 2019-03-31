
RSpec.describe Hammer::Loader::XLSX do
  context "loads a xlsx file" do
    let(:data){loads(:xlsx, filename: "spec/data/example_1.xlsx")}

    it "returns a dataframe" do
      expect(data).to be_instance_of Dataframe
    end

    it "the dataframe contains all the rows" do
      expect(data.size).to eq 294
    end

    it "the dataframe has the correct column type" do
      expect(data.columns.map{|c| c.type}).to eq ["string", "float", "float"]
    end

    it "the dataframe has the correct column names" do
      expect(data.columns.map{|c| c.name}).to eq ["ID", "Latitud", "Longitud"]
    end

    it "stores metadata in dataframe"
  end
end