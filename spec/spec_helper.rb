require 'coveralls'
Coveralls.wear!

require 'pry' unless ENV['CI']
require 'launchpad'
require 'rspec'

RSpec.configure do |config|
  # Exit the javafx toolkit after running specs
  config.after(:suite) { JavaFXImpl::PlatformImpl.tkExit }

  # Remove jrubyfx controller overrides and set the stage double
  config.before(:example, type: :controller) do
    described_class.define_singleton_method(:new) do |*args|
      allocate.tap do |controller|
        stage = args.last && args.last[:stage]
        controller.instance_variable_set(:@stage, stage) if stage
        controller.send :initialize
      end
    end
  end
end
