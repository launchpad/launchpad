require 'coveralls'
Coveralls.wear!

# require 'pry'
require 'rspec'
require 'launchpad'

RSpec.configure do |config|
  # Exit the javafx toolkit after running specs
  config.after(:suite) { JavaFXImpl::PlatformImpl.tkExit }
end
