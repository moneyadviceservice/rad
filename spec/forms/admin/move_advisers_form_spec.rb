RSpec.describe Admin::MoveAdvisersForm, type: :model do
  let(:from_firm) { create(:firm) }
  let(:valid_params) { { id: from_firm.id.to_s } }
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
end
