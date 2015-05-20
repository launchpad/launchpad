require 'spec_helper'

describe Launchpad::Patcher do
  let(:index) { double :index, scan: nil }

  before { allow(Launchpad::Index).to receive(:new).and_return index }

  describe '#in_sync?' do
    context 'when the index reports a diff' do
      let(:index) { double scan: nil, diff: [:x, :y, :z] }

      it { is_expected.to_not be_in_sync }
    end

    context 'when the index diff is empty' do
      let(:index) { double scan: nil, diff: [] }

      it { is_expected.to be_in_sync }
    end
  end

  describe '#progress' do
    it 'defaults to 0' do
      expect(subject.progress).to be_zero
    end
  end

  describe '#progress=' do
    let(:test_callback) { proc { proc_test.test } }
    let(:proc_test) { double test: nil }

    before do
      subject.on_update(&test_callback)
      subject.progress = 10.0
    end

    it 'sets the progress' do
      expect(subject.progress).to eq 10
    end

    it 'calls the update callback' do
      expect(proc_test).to have_received :test
    end
  end
end
