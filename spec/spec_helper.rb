require 'coveralls'
Coveralls.wear!

require 'pry' unless ENV['CI']
require 'launchpad'
require 'rspec'

RSpec.configure do |config|
  # Exit the javafx toolkit after running specs
  config.after(:suite) { JavaFXImpl::PlatformImpl.tkExit }

  # Remove jrubyfx controller overrides
  config.before(:example, type: :controller) do
    described_class.define_singleton_method(:initialize) {}
    described_class.define_singleton_method(:new) { allocate }
  end
end
