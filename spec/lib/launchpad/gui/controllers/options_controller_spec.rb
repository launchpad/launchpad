require 'spec_helper'

describe Launchpad::OptionsController, type: :controller do
  subject do
    described_class.new.tap do |controller|
      controller.instance_variable_set :@stage, stage_double
    end
  end

  let(:stage_double) { double 'stage', close: true }

  let(:options) do
    [:install, :local_index_path, :remote_index_uri, :login_server, :port]
  end

  let(:text_fields) do
    options.reduce({}) do |options, option|
      option_double = double(
        option.to_s.capitalize,
        get_characters: "#{option} value",
        set_text: nil)
      options.merge(option => option_double)
    end
  end

  before do
    described_class::OPTIONS.each do |option|
      allow(subject).to receive(option).and_return text_fields[option]
    end

    allow(Launchpad::Settings).tap do |settings|
      settings.to receive(:read).and_return 'value'
      settings.to receive(:update).and_return true
      settings.to receive(:save).and_return true
    end
  end

  describe '#accept' do
    before { subject.accept }

    it 'closes the stage' do
      expect(stage_double).to have_received :close
    end

    it 'updates all settings with values from the form' do
      options.each do |option|
        expect(Launchpad::Settings).to have_received(:update)
          .with(option, "#{option} value")
      end

      expect(Launchpad::Settings).to have_received :save
    end
  end

  describe '#cancel' do
    before { subject.cancel }

    it 'closes the stage' do
      expect(stage_double).to have_received :close
    end
  end

  describe '#display_values' do
    before { subject.display_values }

    it 'fills in the ui fields with current setting values' do
      options.each do |option|
        expect(text_fields[option]).to have_received(:set_text).with 'value'
      end
    end
  end
end
