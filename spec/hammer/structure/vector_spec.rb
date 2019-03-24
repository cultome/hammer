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
  end

  it "initialize a vector with column type"
  it "initialize a vector with row name"

  it "selects a slice of rows by name"
  it "selects a slice of rows by index"

  it "deletes a row by name"
  it "deletes a row by index"

  it "sums two vectors"

  context "with a valid vector" do
    let(:v){ Vector.new(data: [1,"2"], name: "mixed", type: "int") }

    it "appends a value to the data" do
      v.push(data: "value", type: "string")
      expect(v.data).to eq [1,2,"value"]
    end

    it "appends a type to the vector metadata" do
      v.push(data: "value", type: "string")
      expect(v.types).to eq Set.new(["int", "string"])
    end
  end
end
