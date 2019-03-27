
RSpec.describe Hammer::Statisticable do
  let(:data){loads(:csv, filename: "spec/data/example_1.csv")}

  it "calculate stats for integer" do
    puts data.get("age").stats
  end
end
