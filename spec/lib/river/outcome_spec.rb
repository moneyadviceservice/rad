RSpec.describe River::Outcome do
  let(:result) { '' }
  subject { River::Outcome.new(result) }

  describe '.success?' do
    context 'when true' do
      subject { River::Outcome.new(result).success? }
      it { is_expected.to be true }
    end

    context 'when false' do
      subject { River::Outcome.new(result).success? }
      let(:result) { '' }
      xit { is_expected.to be false }
    end
  end
end
