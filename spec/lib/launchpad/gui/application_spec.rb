require 'spec_helper'

describe Launchpad::Application do
  describe '#start' do
    let(:stage) { double 'stage' }

    before do
      messages = [:title=, :width=, :height=, :resizable=, :fxml, :show]
      messages.each { |message| allow(stage).to receive message }
      subject.start stage
    end

    it 'should set up the stage' do
      expect(stage).to have_received(:title=).with 'Launchpad'
      expect(stage).to have_received(:resizable=).with false
      expect(stage).to have_received(:fxml).with 'main.fxml'
      expect(stage).to have_received(:show)
    end

    it 'should not raise any errors' do
      expect { subject.start stage }.to_not raise_error
    end
  end
end
