module Hammer
  class CleanRoom
    include Hammer

    attr_reader :dataframe
    attr_reader :file_format

    def initialize(dataframe, file_format)
      @dataframe = dataframe
      @file_format = file_format
    end
  end
end
