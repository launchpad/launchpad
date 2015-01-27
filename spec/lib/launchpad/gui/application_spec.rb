require 'spec_helper'

describe Launchpad::Application do
  describe '#start' do
    let(:stage) { double 'stage' }
    let(:messages) { [:title=, :width=, :height=, :resizable=, :fxml, :show] }

    before do
      messages.each { |message| allow(stage).to receive message }
      subject.start stage
    end

    it 'should set up and show the stage' do
      expect(stage).to have_received(:title=).with 'Launchpad'
      expect(stage).to have_received(:resizable=).with false
      expect(stage).to have_received(:fxml).with Launchpad::MainController
      expect(stage).to have_received(:show)
    end
  end
end
