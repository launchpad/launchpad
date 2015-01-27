require 'spec_helper'

describe Launchpad::MainController do
  let(:stage_class) { described_class::Stage }
  let(:stage_double) { double stage_class }
  let(:messages) { [:title=, :on_close_request, :show] }

  before do
    described_class.define_singleton_method(:initialize) {}
    described_class.define_singleton_method(:new) { allocate }

    allow(stage_class).to receive(:new).and_return stage_double
    messages.each { |message| allow(stage_double).to receive message }
  end

  describe '#show_options' do
    before { subject.show_options }

    it 'shows the options stage' do
      expect(stage_double).to have_received :show
    end

    context 'when an options stage already exists' do
      subject do
        described_class.new.tap do |s|
          s.instance_variable_set :@options, stage_double
        end
      end

      it 'does not assign a new stage' do
        expect(stage_class).to_not have_received :new
      end
    end

    context 'when an options stage does not exist' do
      it 'assigns a new titled options stage' do
        expect(subject.instance_variable_get :@options).to be stage_double
        expect(stage_double).to have_received(:title=).with 'Options'
      end

      it 'sets the on_close_request callback' do
        expect(stage_double).to have_received :on_close_request
      end
    end
  end
end
