module Admin
  RSpec.describe FirmsHelper, type: :helper do
    describe '#fca_verified_text' do
      let(:principal) { create(:principal, fca_number: '123456', fca_verified: fca_status) }

      context 'when the fca number has been verified' do
        let(:fca_status) { true }
        it 'returns "fca verified"' do
          expect(helper.fca_verified_text(principal)).to eq 'FCA verified'
        end
      end

      context 'when the fca number has NOT been verified' do
        let(:fca_status) { false }
        it 'returns "NOT fca verified"' do
          expect(helper.fca_verified_text(principal)).to eq 'Not FCA verified'
        end
      end
    end
  end
end
