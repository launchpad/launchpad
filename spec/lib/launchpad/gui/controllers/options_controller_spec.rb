require 'spec_helper'

describe Launchpad::OptionsController do
  subject do
    described_class.new.tap do |controller|
      controller.instance_variable_set :@stage, stage_double
    end
  end

  let(:stage_double) { double 'stage', close: true }

  before do
    described_class.define_singleton_method(:initialize) {}
    described_class.define_singleton_method(:new) { allocate }
  end

  describe '#cancel' do
    before { subject.cancel }

    it 'closes the stage' do
      expect(stage_double).to have_received :close
    end
  end
end
