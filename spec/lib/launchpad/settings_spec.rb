require 'spec_helper'

describe Launchpad::Settings do
  let(:settings_fixture) { 'spec/fixtures/config/settings.yml' }
  let(:settings_path) { 'spec/fixtures/config/current-settings.yml' }

  before do
    FileUtils.copy settings_fixture, settings_path
    stub_const 'Launchpad::Settings::PATH', settings_path
  end

  after do
    File.delete settings_path
  end

  describe '.read' do
    it 'should access saved settings' do
      expect(described_class.read :install)
        .to eq 'test/install'

      expect(described_class.read :login_server)
        .to eq 'http://login.example.com/'
    end
  end

  describe '.update' do
    it 'should update a given settings value' do
      expect { described_class.update :install, 'test/updated' }
        .to change { described_class.read :install }
        .from('test/install')
        .to('test/updated')
    end
  end

  describe '.save' do
    before do
      described_class.update :install, 'test/updated'
      described_class.save
    end

    it 'should update the yaml file with new values' do
      expect(described_class.clone.read :install)
        .to eq 'test/updated'
    end
  end
end
