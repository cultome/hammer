require "csv"
require "date"
require "erb"
require "forwardable"
require "numo/gnuplot"
require "pry"
require "rainbow/refinement"
require "rubyXL"
require "set"
require "tempfile"

require "hammer/version"
require "hammer/detector"
require "hammer/type"
require "hammer/type_cohersion"
require "hammer/refinement"
require "hammer/statisticable"
require "hammer/structure"
require "hammer/util"
require "hammer/loader"
require "hammer/clean_room"

module Hammer
  class Error < StandardError; end

  include Detector
  include Loader
  include Structure
end
