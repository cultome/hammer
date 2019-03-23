require "hammer/version"
require "hammer/type/missing"
require "hammer/type_cohersion"
require "hammer/loader"
require "hammer/analyzer"
require "hammer/structure"
require "hammer/util"

module Hammer
  class Error < StandardError; end

  include Loader
  include Analyzer
  include Structure
end
