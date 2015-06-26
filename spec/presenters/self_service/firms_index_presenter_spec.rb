RSpec.describe SelfService::FirmsIndexPresenter do
  let(:trading_names) { [] }
  let(:lookup_names) { [] }

  describe '#firm_has_trading_names?' do
    subject { described_class.new(nil, trading_names, lookup_names).firm_has_trading_names? }

    context 'when both `trading_names` and `lookup_names` are empty' do
      it { is_expected.to be_falsey }
    end

    context 'when both `trading_names` and `lookup_names` are not empty' do
      let(:trading_names) { [:thing] }
      let(:lookup_names) { [:thing] }
      it { is_expected.to be_truthy }
    end

    context 'when `trading_names` is not empty and `lookup_names` is empty' do
      let(:trading_names) { [:thing] }
      it { is_expected.to be_truthy }
    end

    context 'when `trading_names` is empty and `lookup_names` is not empty' do
      let(:lookup_names) { [:thing] }
      it { is_expected.to be_truthy }
    end
  end

  describe '#total_firms' do
    subject { described_class.new(nil, trading_names, lookup_names).total_firms }

    context 'when both `trading_names` and `lookup_names` are empty' do
      it { is_expected.to eq(1) }
    end

    context 'when `trading_names` and `lookup_names` contain one element each' do
      let(:trading_names) { [:thing] }
      let(:lookup_names) { [:thing] }
      it { is_expected.to eq(3) }
    end

    context 'when `trading_names` contains one element and `lookup_names` is empty' do
      let(:trading_names) { [:thing] }
      it { is_expected.to eq(2) }
    end

    context 'when `trading_names` is empty and `lookup_names` contains one element' do
      let(:lookup_names) { [:thing] }
      it { is_expected.to eq(2) }
    end
  end

  describe '#no_trading_names_have_been_added?' do
    subject { described_class.new(nil, trading_names, lookup_names).no_trading_names_have_been_added? }
    context 'when `trading_names` is empty' do
      it { is_expected.to be_truthy }
    end

    context 'when `trading_names` is not empty' do
      let(:trading_names) { [:thing] }
      it { is_expected.to be_falsey }
    end
  end

  describe '#trading_names_are_available_to_add?' do
    subject { described_class.new(nil, trading_names, lookup_names).trading_names_are_available_to_add? }
    context 'when `lookup_names` is empty' do
      it { is_expected.to be_falsey }
    end

    context 'when `lookup_names` is not empty' do
      let(:lookup_names) { [:thing] }
      it { is_expected.to be_truthy }
    end
  end
end
