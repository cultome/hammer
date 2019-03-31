require "hammer/loader/csv"
require "hammer/loader/xlsx"

module Hammer::Loader
  include CSV
  include XLSX

  def loads(type, filename:)
    case type
    when :csv then load_csv(filename)
    when :xlsx then load_xlsx(filename)
    end
  end
end
