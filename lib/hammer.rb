require "hammer/version"
require "hammer/type/missing"
require "hammer/type_cohersion"
require "hammer/detector"
require "hammer/loader"
require "hammer/analyzer"
require "hammer/structure"
require "hammer/util"

module Hammer
  class Error < StandardError; end

  include Detector
  include Loader
  include Analyzer
  include Structure
end
