RSpec.describe River::Outcome do
  let(:result)  { '' }
  let(:outcome) { River::Outcome.new { result } }

  describe '.success?' do
    subject { outcome.success? }

    context 'when result valid' do
      it { is_expected.to be true }
    end

    context 'when result is kind of Exception' do
      let(:result) { Exception.new }
      it { is_expected.to be false }
    end

    context 'when result is kind of Sidekiq::Shutdown' do
      let(:result) { Sidekiq::Shutdown.new }
      it { is_expected.to be false }
    end
  end

  describe '.to_s' do
    it 'returns hash string' do
      expect(outcome.to_s).to eq '{:success=>true}'
    end
  end
end
