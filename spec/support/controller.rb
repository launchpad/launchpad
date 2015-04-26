module Launchpad
  module RSpec
    # Remove the jrubyfx controller overrides and set the stage double.
    module Controller
      extend ::RSpec::SharedContext

      let(:stage) { double 'stage', on_shown: true, close: true }

      subject do
        described_class.allocate.tap do |controller|
          controller.instance_variable_set :@stage, stage
          controller.send :initialize
        end
      end
    end
  end
end
