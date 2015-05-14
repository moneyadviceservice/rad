RSpec.describe Admin::MoveAdvisersForm, type: :model do
  let(:adviser) { create(:adviser) }
  let(:from_firm) { create(:firm) }
  let(:destination_firm) { create(:firm) }
  let(:valid_params) do
    {
      id: from_firm.id.to_s,
      adviser_ids: [adviser.id.to_s],
      destination_firm_fca_number: destination_firm.fca_number,
      destination_firm_id: destination_firm.id.to_s
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

  describe '#destination_firm' do
    let!(:destination_firm) { create(:firm) }
    context 'when the to firm exists' do
      let(:params) { { destination_firm_id: destination_firm.id } }

      it 'returns the firm' do
        expect(subject.destination_firm).to eq(destination_firm)
      end
    end

    context 'when the to firm fca number does not exist' do
      let(:params) { { destination_firm_id: 'NONSENSE' } }

      it 'raises an error' do
        expect { subject.destination_firm }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the to firm id is missing' do
      let(:params) { {} }

      it 'raises an error' do
        expect { subject.destination_firm }.to raise_error(ActiveRecord::RecordNotFound)
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

    describe '#destination_firm_fca_number' do
      context 'do not validate' do
        let(:params) { valid_params.tap { |p| p[:destination_firm_fca_number] = 'DOES_NOT_EXIST' } }

        it 'is not validated when `validate_destination_firm_fca_number` is false' do
          subject.validate_destination_firm_fca_number = nil
          is_expected.to be_valid
        end
      end

      context 'validate' do
        before { subject.validate_destination_firm_fca_number = true }

        context 'destination_firm_fca_number is invalid' do
          let(:params) { valid_params.tap { |p| p[:destination_firm_fca_number] = 'DOES_NOT_EXIST' } }
          it { is_expected.not_to be_valid }
        end

        context 'destination_firm_fca_number is valid' do
          it { is_expected.to be_valid }
        end
      end
    end

    describe '#destination_firm_id' do
      context 'do not validate' do
        let(:params) { valid_params.tap { |p| p.delete(:destination_firm_id) } }

        it 'is not validated when `validate_destination_firm_id` is false' do
          subject.validate_destination_firm_id = nil
          is_expected.to be_valid
        end
      end

      context 'validate' do
        before { subject.validate_destination_firm_id = true }

        context 'without destination_firm_id' do
          let(:params) { valid_params.tap { |p| p.delete(:destination_firm_id) } }
          it { is_expected.not_to be_valid }
        end

        context 'with destination_firm_id' do
          it { is_expected.to be_valid }
        end
      end
    end
  end

  describe '#advisers_to_move' do
    let(:fred) { create(:adviser, reference_number: 'FXX12345') }
    let(:sarah) { create(:adviser, reference_number: 'SXX12345') }
    let(:alan) { create(:adviser, reference_number: 'AXX12345') }
    let(:params) { { adviser_ids: [fred.id, sarah.id, alan.id] } }

    it 'are sorted by reference number' do
      reference_numbers = subject.advisers_to_move.map(&:reference_number)
      expect(reference_numbers).to eq(['AXX12345', 'FXX12345', 'SXX12345'])
    end
  end

  describe '#subsidiaries' do
    let(:shared_fca_number) { 123456 }
    let!(:wendys_firm) { create(:firm, registered_name: 'Wendys Firm', fca_number: shared_fca_number) }
    let!(:alberts_firm) { create(:firm, registered_name: 'Alberts Firm', fca_number: shared_fca_number) }
    let!(:sandras_firm) { create(:firm, registered_name: 'Sandras Firm', fca_number: shared_fca_number) }
    let!(:unrelated_firm) { create(:firm, registered_name: 'Unrelated Firm', fca_number: 999999) }
    let!(:no_registered_firm) do
      f = build(:firm, email_address: nil, fca_number: shared_fca_number )
      f.save!(validate: false)
      f
    end
    let!(:params) { {destination_firm_fca_number: shared_fca_number} }

    it 'does not include firm without the shared fca number' do
      expect(subject.subsidiaries).not_to include(unrelated_firm)
    end

    it 'does not include firms that have not been registered' do
      expect(subject.subsidiaries).not_to include(no_registered_firm)
    end

    it 'includes only firms with the supplied fca number' do
      all_shared = subject.subsidiaries.all?{ |s| s.fca_number == shared_fca_number }
      expect(all_shared).to eq(true)
    end

    it 'sorts the firms by registered_name' do
      names = subject.subsidiaries.map(&:registered_name)
      expect(names).to eq(['Alberts Firm', 'Sandras Firm', 'Wendys Firm'])
    end

    context 'sorts irrelevant of case' do
      let!(:andrews_firm) { create(:firm, registered_name: 'andrews Firm', fca_number: shared_fca_number) }

      it 'sorts the firms by registered_name' do
        expect(subject.subsidiaries).to eq([alberts_firm, andrews_firm, sandras_firm, wendys_firm])
      end
    end
  end
end
