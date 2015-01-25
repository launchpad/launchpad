require 'coveralls'
Coveralls.wear!

require 'pry' unless ENV['CI']
require 'launchpad'
require 'rspec'

RSpec.configure do |config|
  # Exit the javafx toolkit after running specs
  config.after(:suite) { JavaFXImpl::PlatformImpl.tkExit }
end
