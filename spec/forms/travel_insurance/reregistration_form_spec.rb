RSpec.describe TravelInsurance::ReregistrationForm, type: :model do
  let(:travel_insurance_firm) { FactoryBot.create(:travel_insurance_firm, :with_principal) }
  let(:valid_params) { { confirmed_disclaimer: '1' } }

  subject { described_class.new(travel_insurance_firm, valid_params) }

  context 'with valid params' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  it 'delegates `fca_number` to the underlying firm' do
    expect(subject.fca_number).to eq(travel_insurance_firm.fca_number)
  end
end
