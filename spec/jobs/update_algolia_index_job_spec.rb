RSpec.describe UpdateAlgoliaIndexJob do
  describe 'sidekiq settings' do
    it { is_expected.to be_processed_in :default }
    it { is_expected.to be_retryable 15 }
    it { is_expected.to save_backtrace }
  end

  describe '#perform' do
    subject(:perform_job) { described_class.new(klass, id).perform_now }

    let(:klass) { 'Firm' }
    let(:id) { 1 }

    it 'handles the record update in the index' do
      expect(AlgoliaIndex).to receive(:handle_update!)
        .with(klass: klass, id: id).exactly(:once)

      perform_job
    end
  end
end
