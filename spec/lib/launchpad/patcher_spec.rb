require 'spec_helper'

describe Launchpad::Patcher do
  let(:index) { double :index }

  before { allow(Launchpad::Index).to receive(:new).and_return index }

  describe '#in_sync?' do
    context 'when the index reports a diff' do
      let(:index) { double diff: [:x, :y, :z] }

      it { is_expected.to_not be_in_sync }
    end

    context 'when the index diff is empty' do
      let(:index) { double diff: [] }

      it { is_expected.to be_in_sync }
    end
  end
end
