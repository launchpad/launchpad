require 'spec_helper'

describe Launchpad::OptionsController, type: :controller do
  subject do
    described_class.new.tap do |controller|
      controller.instance_variable_set :@stage, stage_double
    end
  end

  let(:stage_double) { double 'stage', close: true }

  describe '#cancel' do
    before { subject.cancel }

    it 'closes the stage' do
      expect(stage_double).to have_received :close
    end
  end
end
