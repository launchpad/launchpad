require 'spec_helper'

describe Index do
  subject { described_class.new target }

  let(:target) { Pathname.new 'spec/fixtures/test_dir' }

  describe '#scan' do
    it 'loads the files in the root directory' do
      expect{ subject.scan }
        .to change { subject.files.count }
        .from(0).to(10)
    end
  end

  describe '#files' do
    before { subject.scan }

    it 'returns an array of all file paths' do
      expect(subject.files).to be_an Array
    end

    it 'includes the file paths' do
      expect(subject.files.last.first.to_s)
        .to eq 'spec/fixtures/test_dir/file_1.txt'
    end

    it 'includes the md5 sums' do
      expect(subject.files.last.last.to_s)
        .to eq '5bbf5a52328e7439ae6e719dfe712200'
    end
  end
end
