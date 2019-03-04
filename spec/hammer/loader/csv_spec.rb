
RSpec.describe Hammer::Loader::CSV do
  xit "loads a dataframe" do
    df = load_csv "data/example_1.csv"
    expect(df).to be_a Dataframe
  end
end
