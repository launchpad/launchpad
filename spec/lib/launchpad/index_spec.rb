require 'spec_helper'

describe Index do
  subject { described_class.new args }

  let(:target_dir) { Pathname.new 'spec/fixtures/test_dir' }
  let(:local_index_path) { 'spec/fixtures/indexes/local' }
  let(:remote_index_uri) { 'https://patch.cuemu.com/index' }

  let(:args) do
    { target_dir: target_dir,
      remote_index_uri: remote_index_uri,
      local_index_path: local_index_path }
  end

  describe '#diff' do
    let(:remote_index_uri) { 'spec/fixtures/indexes/remote' }

    before do
      subject.local
      subject.local_index_path = remote_index_uri
      subject.remote = subject.send :parse_local
    end

    it 'returns an array of needed files' do
      expect(subject.diff).to eq [
        'path/file_2.txt', 'path/file_4.txt', 'path/file_6.txt',
        'path/file_7.txt', 'path/file_8.txt'
      ]
    end
  end

  describe '#local' do
    context 'when an index is found' do
      let(:local_index_path) { 'spec/fixtures/indexes/local' }

      it 'returns an index of files' do
        expect(subject.local.last.first).to eq 'path/file_5.txt'
        expect(subject.local.last.last).to eq 'fake5md5'
      end
    end

    context 'when an index is not found' do
      let(:local_index_path) { 'spec/fixtures/nope' }

      it 'returns false' do
        expect(subject.local).to be false
      end
    end
  end

  describe '#remote' do
    context 'when an index is found' do
      before do
        allow(Kernel).to receive :open
        subject.remote
      end

      it 'opens and reads the remote file' do
        expect(Kernel).to have_received(:open).with remote_index_uri
      end
    end

    context 'when an index is not found' do
      before { allow(Kernel).to receive(:open).and_raise Errno::ENOENT }

      it 'returns false' do
        expect(subject.remote).to be false
      end
    end
  end

  describe '#scan' do
    let(:local_index) { StringIO.new }

    before do
      allow(subject).to receive(:open_local).and_return local_index
      allow(local_index).to receive :close
      subject.scan
      local_index.pos = 0
    end

    it 'updates with a full scan' do
      expect(subject.local.size).to eq 10

      expect(subject.local.last.first.to_s)
        .to eq 'spec/fixtures/test_dir/file_1.txt'

      expect(subject.local.last.last.to_s)
        .to eq '5bbf5a52328e7439ae6e719dfe712200'
    end

    it 'caches all the data' do
      expect(local_index.readlines.count).to eq 10
    end

    it 'saves in the correct format' do
      expect(local_index.readlines.last)
        .to match(/^[\w\/]*file_1.txt \| 5b\w*$/)
    end
  end
end
