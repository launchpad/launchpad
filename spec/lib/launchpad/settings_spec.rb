require 'spec_helper'

describe Settings do
  describe 'accessing default values' do
    describe '.local_index_path' do
      specify { expect(described_class.local_index_path).to eq 'index' }
    end

    describe '.remote_index_uri' do
      specify do
        expect(described_class.remote_index_uri)
          .to eq 'http://patcher.cuemu.com/index'
      end
    end
  end
end
