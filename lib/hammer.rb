require "hammer/version"
require "hammer/loader"
require "hammer/analyzer"
require "hammer/structure"
require "hammer/util"

module Hammer
  class Error < StandardError; end

  include Loader
  include Analyzer
end
