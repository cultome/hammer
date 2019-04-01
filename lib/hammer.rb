require "hammer/version"
require "hammer/type"
require "hammer/type_cohersion"
require "hammer/detector"
require "hammer/loader"
require "hammer/structure"
require "hammer/util"

module Hammer
  class Error < StandardError; end

  include Detector
  include Loader
  include Structure
end
