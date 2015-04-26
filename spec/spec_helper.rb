require 'coveralls'
Coveralls.wear!

require 'pry' unless ENV['CI']
require 'launchpad'
require 'rspec'
require 'support'

RSpec.configure do |config|
  # Exit the javafx toolkit after running specs
  config.after(:suite) { JavaFXImpl::PlatformImpl.tkExit }

  # Set type to controller for all specs in the controllers folder
  config.define_derived_metadata(file_path: /controllers/) do |metadata|
    metadata[:type] ||= :controller
  end

  # Include the controller shared context for all controller specs
  config.include Launchpad::RSpec::Controller, type: :controller
end
