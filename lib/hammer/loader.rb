require "hammer/loader/csv"
require "hammer/loader/xlsx"

module Hammer::Loader
  include CSV
  include XLSX

  def loads(type, filename:, extras: {})
    send("load_#{type}", filename, extras: extras)
  end
end
