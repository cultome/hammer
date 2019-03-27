
RSpec.describe Hammer::Statisticable do
  let(:data){loads(:csv, filename: "spec/data/example_1.csv")}

  it "calculate stats for integer" do
    stats = data.get("age").stats

    expect(stats).to have_key :count
    expect(stats).to have_key :sum
    expect(stats).to have_key :max
    expect(stats).to have_key :min
    expect(stats).to have_key :avg
  end

  it "calculate stats for date" do
    stats = data.get("join").stats

    expect(stats).to have_key :min
    expect(stats).to have_key :max
  end
end
