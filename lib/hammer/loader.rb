require "hammer/loader/csv"

module Hammer::Loader
  include CSV

  def loads(type, filename:)
    load_csv(filename)
  end
end
