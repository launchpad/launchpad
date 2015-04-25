require 'spec_helper'

describe Launchpad::UpdateManager do
  subject { described_class.new controller }

  let(:controller) { double :controller, status: double(set_text: nil) }

  before { allow(Launchpad::Patcher).to receive(:new).and_return patcher }

  describe '#scan' do
    before { subject.scan }

    context 'when fils are in sync' do
      let(:patcher) { double :patcher, in_sync?: true }

      it 'displays a message that files are synced' do
        expect(controller.status).to have_received(:set_text).with 'Ready'
      end
    end

    context 'when fils are out of sync' do
      let(:patcher) { double :patcher, in_sync?: false }

      it 'displays a message that there are files that need syncing' do
        expect(controller.status)
          .to have_received(:set_text).with 'Update required...'
      end
    end
  end
end
