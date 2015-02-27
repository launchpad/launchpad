require 'spec_helper'

describe Launchpad::Settings do
  describe '.read' do
    it 'should access saved settings' do
      expect(described_class.read :install)
        .to eq 'test/install'
      expect(described_class.read :login_server)
        .to eq 'http://login.example.com/'
    end
  end
end
