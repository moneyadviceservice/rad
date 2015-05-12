RSpec.describe Admin::MoveAdvisersForm, type: :model do
  let(:adviser) { create(:adviser) }
  let(:from_firm) { create(:firm) }
  let(:to_firm) { create(:firm) }
  let(:valid_params) do
    {
      id: from_firm.id.to_s,
      adviser_ids: [adviser.id.to_s],
      to_firm_fca_number: to_firm.fca_number
    }
  end
  let(:params) { valid_params }

  subject { described_class.new(params) }

  describe '#from_firm' do
    context 'when the from firm exists' do
      let(:params) { { id: from_firm.id.to_s } }

      it 'returns the firm' do
        expect(subject.from_firm).to eq(from_firm)
      end
    end

    context 'when the from firm does not exist' do
      let(:params) { { id: (from_firm.id * 10).to_s } }

      it 'raises an error' do
        expect { subject.from_firm }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the from firm id is missing' do
      let(:params) { valid_params.tap { |p| p.delete(:id) } }

      it 'raises an error' do
        expect { subject.from_firm }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#adviser_ids=' do
    let(:params) { valid_params.tap { |p| p[:adviser_ids] << '' } }

    it 'strips out the default ghost value introduced by `collection_check_boxes`' do
      expect(subject.adviser_ids).to eq([adviser.id.to_s])
    end
  end

  describe 'validation' do
    describe '#adviser_ids' do
      context 'when some adviser_ids have been specified' do
        it { is_expected.to be_valid }
      end

      context 'when no adviser_ids have been specified' do
        let(:params) { valid_params.tap { |p| p[:adviser_ids] = [] } }
        it { is_expected.not_to be_valid }
      end

      context 'when adviser_ids is missing' do
        let(:params) { valid_params.tap { |p| p.delete(:adviser_ids) } }
        it { is_expected.not_to be_valid }
      end
    end

    describe '#to_firm_fca_number' do
      context 'do not validate' do
        let(:params) { valid_params.tap { |p| p[:to_firm_fca_number] = 'DOES_NOT_EXIST' } }

        it 'is not validated when `validate_to_firm_fca_number` is false' do
          subject.validate_to_firm_fca_number = nil
          is_expected.to be_valid
        end
      end

      context 'validate' do
        before { subject.validate_to_firm_fca_number = true }

        context 'to_firm_fca_number is invalid' do
          let(:params) { valid_params.tap { |p| p[:to_firm_fca_number] = 'DOES_NOT_EXIST' } }
          it { is_expected.not_to be_valid }
        end

        context 'to_firm_fca_number is valid' do
          it { is_expected.to be_valid }
        end
      end
    end
  end
end
