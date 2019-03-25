require "csv"

module Hammer::Loader
  module CSV
    def load_csv(filename)
      data = ::CSV.open(filename).readlines

      Dataframe.new(data: data)
    end
  end
end
