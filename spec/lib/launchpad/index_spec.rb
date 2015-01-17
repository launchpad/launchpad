require 'spec_helper'

describe Index do
  subject { described_class.new args }

  let(:target_dir) { Pathname.new 'spec/fixtures/test_dir' }
  let(:index_location) { target_dir.join 'index' }

  let(:args) do
    { target_dir: target_dir,
      index_location: index_location }
  end

  describe '#local_files' do
    before { subject.scan }

    it 'returns an array of all file paths' do
      expect(subject.local_files).to be_an Array
    end

    it 'includes the file paths' do
      expect(subject.local_files.last.first.to_s)
        .to eq 'spec/fixtures/test_dir/file_1.txt'
    end

    it 'includes the md5 sums' do
      expect(subject.local_files.last.last.to_s)
        .to eq '5bbf5a52328e7439ae6e719dfe712200'
    end
  end

  describe '#local_index' do
    before { allow(File).to receive(:open) }

    context 'with no arguments' do
      before { subject.local_index }

      it 'opens a file at the index location in read mode' do
        expect(File).to have_received(:open)
          .with index_location, 'r'
      end
    end

    context 'when passed a write mode' do
      before { subject.local_index mode: 'w' }

      it 'opens a file at the index location in write mode' do
        expect(File).to have_received(:open)
          .with index_location, 'w'
      end
    end
  end

  describe '#load' do
    context 'when there is not an index file available' do
      let(:index_location) { 'spec/fixtures/nope' }

      it 'returns false' do
        expect(subject.load).to be false
      end
    end

    context 'when there is an index file available' do
      let(:index_location) { 'spec/fixtures/index' }

      it 'returns true' do
        expect(subject.load).to be true
      end

      it 'loads a previously saved index to memory' do
        expect{ subject.load }
          .to change { subject.local_files.count }
          .from(0).to(2)

        expect(subject.local_files.last.first.to_s)
          .to eq 'path/file_2.txt'

        expect(subject.local_files.last.last.to_s)
          .to eq 'fake2md5'
      end
    end
  end

  describe '#save' do
    let(:local_index) { StringIO.new }

    before do
      allow(subject)
        .to receive(:local_index)
        .and_return local_index

      allow(local_index)
        .to receive(:close)

      subject.save
      local_index.pos = 0
    end

    it 'saves all the data' do
      expect(local_index.readlines.count).to eq 10
    end

    it 'saves in the correct format' do
      expect(local_index.readlines.last)
        .to match(/^[\w\/]*file_1.txt \| 5b\w*$/)
    end

    it 'closes the file when done' do
      expect(local_index).to have_received :close
    end
  end

  describe '#scan' do
    it 'loads the files in the root directory' do
      expect{ subject.scan }
        .to change { subject.local_files.count }
        .from(0).to(10)

      expect(subject.local_files.last.first.to_s)
        .to eq 'spec/fixtures/test_dir/file_1.txt'

      expect(subject.local_files.last.last.to_s)
        .to eq '5bbf5a52328e7439ae6e719dfe712200'
    end
  end
end
