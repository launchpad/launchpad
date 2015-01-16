require 'spec_helper'

describe Index do
  subject { described_class.new args }

  let(:target_dir) { Pathname.new 'spec/fixtures/test_dir' }
  let(:index_location) { target_dir.join 'index' }

  let(:args) do
    { target_dir: target_dir,
      index_location: index_location }
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

  describe '#index_file' do
    before { allow(File).to receive(:open) }

    context 'with no arguments' do
      before { subject.index_file }

      it 'opens a file at the index location in read mode' do
        expect(File).to have_received(:open)
          .with index_location, 'r'
      end
    end

    context 'when passed a write mode' do
      before { subject.index_file mode: 'w' }

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
          .to change { subject.files.count }
          .from(0).to(2)

        expect(subject.files.last.first.to_s)
          .to eq 'path/file_2.txt'

        expect(subject.files.last.last.to_s)
          .to eq 'fake2md5'
      end
    end
  end

  describe '#save' do
    let(:index_file) { StringIO.new }

    before do
      allow(subject)
        .to receive(:index_file)
        .and_return index_file

      allow(index_file)
        .to receive(:close)

      subject.save
      index_file.pos = 0
    end

    it 'saves all the data' do
      expect(index_file.readlines.count).to eq 10
    end

    it 'saves in the correct format' do
      expect(index_file.readlines.last)
        .to match(/^[\w\/]*file_1.txt - 5b\w*$/)
    end

    it 'closes the file when done' do
      expect(index_file).to have_received :close
    end
  end

  describe '#scan' do
    it 'loads the files in the root directory' do
      expect{ subject.scan }
        .to change { subject.files.count }
        .from(0).to(10)

      expect(subject.files.last.first.to_s)
        .to eq 'spec/fixtures/test_dir/file_1.txt'

      expect(subject.files.last.last.to_s)
        .to eq '5bbf5a52328e7439ae6e719dfe712200'
    end
  end
end
