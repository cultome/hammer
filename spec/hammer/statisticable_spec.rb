
RSpec.describe Hammer::Statisticable do
  let(:data){loads(:csv, filename: "spec/data/example_1.csv")}

  it "calculate stats for integer" do
    stats = data.get_col("age").stats

    %I[count sum max invalid min avg median].each do |key|
      expect(stats).to have_key key
    end
  end

  it "calculate stats for date" do
    stats = data.get_col("join").stats

    expect(stats).to have_key :min
    expect(stats).to have_key :max
  end
end
