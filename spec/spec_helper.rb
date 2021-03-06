require 'simplecov'
SimpleCov.start

require "bundler/setup"
require "hammer"
require "date"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

include Hammer
