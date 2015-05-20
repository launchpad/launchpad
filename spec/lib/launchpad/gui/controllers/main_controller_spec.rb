require 'spec_helper'

describe Launchpad::MainController do
  let(:patcher) { instance_double Launchpad::Patcher, on_update: nil }
  let(:stage) { double 'stage', on_shown: true }
  let(:status) { double 'status', set_text: nil }

  before do
    allow(Launchpad::Patcher).to receive(:new).and_return patcher
    allow(subject).to receive(:status).and_return status
  end

  describe '#initialize' do
    before { subject }

    it 'sets up an patcher' do
      expect(subject.patcher).to be patcher
    end

    it 'sets up the on_shown hook' do
      expect(stage).to have_received :on_shown
    end
  end

  describe '#scan' do
    before do
      stub_const 'Platform', double
      allow(Thread).to receive(:new).and_yield
      allow(Platform).to receive(:run_later).and_yield
      allow(Launchpad::Patcher).to receive(:new).and_return patcher
      subject.scan
    end

    context 'when files are in sync' do
      let(:patcher) do
        instance_double Launchpad::Patcher, on_update: nil, in_sync?: true
      end

      it 'displays a message that files are synced' do
        expect(subject.status).to have_received(:set_text).with 'Ready'
      end
    end

    context 'when files are out of sync' do
      let(:patcher) do
        instance_double Launchpad::Patcher, on_update: nil, in_sync?: false
      end

      it 'displays a message that there are files that need syncing' do
        expect(subject.status)
          .to have_received(:set_text).with 'Update required...'
      end
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
      options = { :title= => 'Options',
                  :always_on_top= => true,
                  :resizable= => false,
                  :x= => 25,
                  :y= => 45 }

      options.each do |option, setting|
        expect(options_stage).to have_received(option).with setting
      end
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
