require 'spec_helper'

describe Launchpad::MainController, type: :controller do
  let(:stage_class) { described_class::Stage }
  let(:stage_double) { double 'stage' }

  let(:messages) do
    [:title=, :always_on_top=, :resizable=, :fxml=, :show, :x=, :y=]
  end

  before do
    allow(stage_class).to receive(:new).and_return stage_double
    messages.each { |message| allow(stage_double).to receive message }

    [:x, :y].each do |axis|
      allow(Launchpad::Application)
        .to receive_message_chain(:main_stage, axis)
        .and_return 5
    end
  end

  describe '#show_options' do
    before { subject.show_options }

    it 'assigns a new options stage' do
      expect(subject.instance_variable_get :@options).to be stage_double
    end

    it 'uses the options controller for the stage' do
      expect(stage_double).to have_received(:fxml=)
        .with Launchpad::OptionsController
    end

    it 'sets the options stage attributes' do
      expect(stage_double).to have_received(:title=).with 'Options'
      expect(stage_double).to have_received(:always_on_top=).with true
      expect(stage_double).to have_received(:resizable=).with false
      expect(stage_double).to have_received(:x=).with 25
      expect(stage_double).to have_received(:y=).with 45
    end

    it 'shows the options stage' do
      expect(stage_double).to have_received :show
    end

    context 'when called more than once' do
      before { subject.show_options }

      it 'does not create a new stage every time' do
        expect(stage_class).to have_received(:new).once
      end

      it 'calls show every time' do
        expect(stage_double).to have_received(:show).twice
      end
    end
  end
end
