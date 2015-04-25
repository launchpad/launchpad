require 'spec_helper'

describe Launchpad::MainController, type: :controller do
  subject { described_class.new stage: stage_double }

  let(:stage_double) { double 'stage', on_shown: true }

  before { allow(Launchpad::UpdateManager).to receive :new }

  describe '#initialize' do
    let(:update_manager) { double 'update_manager' }

    before do
      allow(Launchpad::UpdateManager).to receive(:new).and_return update_manager
      subject
    end

    it 'sets up an update manager' do
      expect(subject.update_manager).to be update_manager
    end

    it 'sets up the on_shown hook' do
      expect(stage_double).to have_received :on_shown
    end
  end

  describe '#show_options' do
    let(:options_stage) { double 'stage' }
    let(:stage_class) { described_class::Stage }

    let(:messages) do
      [:title=, :always_on_top=, :resizable=, :fxml=, :show, :x=, :y=]
    end

    before do
      allow(stage_class).to receive(:new).and_return options_stage
      messages.each { |message| allow(options_stage).to receive message }

      [:x, :y].each do |axis|
        allow(Launchpad::Application)
          .to receive_message_chain(:main_stage, axis)
          .and_return 5
      end

      subject.show_options
    end

    it 'assigns a new options stage' do
      expect(subject.instance_variable_get :@options).to be options_stage
    end

    it 'uses the options controller for the stage' do
      expect(options_stage).to have_received(:fxml=)
        .with Launchpad::OptionsController
    end

    it 'sets the options stage attributes' do
      expect(options_stage).to have_received(:title=).with 'Options'
      expect(options_stage).to have_received(:always_on_top=).with true
      expect(options_stage).to have_received(:resizable=).with false
      expect(options_stage).to have_received(:x=).with 25
      expect(options_stage).to have_received(:y=).with 45
    end

    it 'shows the options stage' do
      expect(options_stage).to have_received :show
    end

    context 'when called more than once' do
      before { subject.show_options }

      it 'does not create a new stage every time' do
        expect(stage_class).to have_received(:new).once
      end

      it 'calls show every time' do
        expect(options_stage).to have_received(:show).twice
      end
    end
  end
end
