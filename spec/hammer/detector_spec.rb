
RSpec.describe Hammer::Detector do
  it "detect format of a csv file" do
    expect(detect_format("spec/data/example_1.csv")).to eq :csv
  end

  it "detect format of a xlsx file" do
    expect(detect_format("spec/data/example_1.xlsx")).to eq :xlsx
  end
end
