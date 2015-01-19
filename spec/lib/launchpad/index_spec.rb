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
      subject.instance_variable_set :@local_index_path, remote_index_uri
      subject.instance_variable_set :@remote, subject.send(:parse_local)
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
        expect(subject.local.first.first).to eq 'path/file_1.txt'
        expect(subject.local.first.last).to eq 'fake1md5'
      end
    end

    context 'when an index is not found' do
      let(:local_index_path) { 'spec/fixtures/nope' }

      it 'returns an empty array' do
        expect(subject.local).to eq []
      end
    end
  end

  describe '#remote' do
    context 'when an index is found' do
      before do
        allow(Kernel).to receive(:open).and_raise Errno::ENOENT
        subject.remote
      end

      it 'opens and reads the remote file' do
        expect(Kernel).to have_received(:open).with remote_index_uri
      end
    end

    context 'when an index is not found' do
      before { allow(Kernel).to receive(:open).and_raise Errno::ENOENT }

      it 'returns an empty array' do
        expect(subject.remote).to eq []
      end
    end
  end

  describe '#scan' do
    let(:local_index) { StringIO.new }

    before do
      allow(File).to receive(:open).and_return local_index
      allow(local_index).to receive :close
      subject.scan
      local_index.pos = 0
    end

    it 'updates with a full scan' do
      expect(subject.local.size).to eq 10

      expect(subject.local.first.first)
        .to eq 'spec/fixtures/test_dir/file_1.txt'

      expect(subject.local.first.last)
        .to eq 'd41d8cd98f00b204e9800998ecf8427e'
    end

    it 'caches all the data' do
      expect(local_index.readlines.count).to eq 10
    end

    it 'saves in the correct format' do
      expect(local_index.readlines.first)
        .to match(/^[\w\/]*file_1.txt \| d4\w*$/)
    end
  end
end
