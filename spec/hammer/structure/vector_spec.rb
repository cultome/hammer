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
      let(:v){ Vector.new(data: [1,"2",3.5,Missing.new,5], name: "my mixed col", type: "integer") }

      it "should convert item to the given type" do
        expect(v.type).to eq "integer"
      end
    end
  end

  context "with a valid vector" do
    let(:v){ Vector.new(data: [1,"2"], name: "mixed", type: "integer") }

    it "appends a value to the data" do
      v.push(value: "value", value_type: "string")

      expect(v.data.size).to eq 3
    end

    it "detects a more general type" do
      v.push(value: "value", value_type: "string")

      expect(v.type).to eq "string"
    end

    it "convert the whole vector to the more general type" do
      v.push(value: "value", value_type: "string")

      expect(v.data).to eq ["1","2","value"]
    end

    it "get a value by index" do
      expect(v[1]).to eq 2
    end

    it "get multiple values by index" do
      expect(v.fetch(0,1)).to eq [1,2]
    end

    it "deletes a row by name"
    it "deletes a row by index"

    it "sums two vectors"
  end
end
