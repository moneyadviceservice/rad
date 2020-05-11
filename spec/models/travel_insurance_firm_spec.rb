RSpec.describe TravelInsuranceFirm, type: :model do
  context 'when a cached questions exist for a firm before saving it' do
    let(:travel_firm) do
      existing_principal = create(:principal, manually_build_firms: true)
      TravelInsuranceFirm.cache_question_answers(fca_number: existing_principal.fca_number, email: existing_principal.email_address, covered_by_ombudsman_question: true)
      TravelInsuranceFirm.create(fca_number: existing_principal.fca_number, registered_name: 'Test Travel Firm')
    end
    # TravelInsuranceFirm.new(firm.save).to be.true
    describe 'saving the travel firm' do
      it 'will add the cached question value to the saved firm' do
        travel_firm.save
        expect(travel_firm.covered_by_ombudsman_question).to be true
      end
    end
  end
  # describe 'cached question ansewers not set directly on the model' do
  # TravelInsuranceFirm.cache_question_answers(fca_number: firm.fca_number, email: principal.email_address, covered_by_ombudsman_question: true)
  # it 'get saved along with the model' do
  # found_firm = TravelInsuranceFirm.find_by(fca_number: firm.fca_number)
  # expect(found_firm.covered_by_ombudsman_question).to be.truthy
  # end
  # it 'get cleared from the internal cache' do
  # end
  # end
  # describe 'cached question ansewers also set directly on the model' do
  # it 'do not get updated from the cache' do
  # end
  # it 'get cleared from the internal cache' do
  # end
  # end
  # end
  # describe 'non-cached question answers' do
  # describe 'not set directly on the model' do
  # it 'do not get saved along with the model' do
  # end
  # it 'are not present in the cache' do
  # end
  # end
  # describe 'set directly on the model' do
  # it 'get saved unchanged along with the model' do
  # end
  # it 'do not exist in the cache' do
  # end
  # end
  # end

  # context 'and the firm is not successfully saved' do
  # describe 'cached question ansewers not set directly on the model' do
  # it 'do not get saved' do
  # end
  # it 'get cleared from the internal cache' do
  # end
  # end
  # describe 'cached question ansewers also set directly on the model' do
  # it 'do not get updated from the cache' do
  # end
  # it 'get cleared from the internal cache' do
  # end
  # end
  # end
  # describe 'non-cached question answers' do
  # describe 'not set directly on the model' do
  # it 'do not get saved' do
  # end
  # it 'are not present in the cache' do
  # end
  # end
  # describe 'set directly on the model' do
  # it 'do not get saved' do
  # end
  # it 'do not exist in the cache' do
  # end
  # end
  # end
  # end

  # context 'when the corresponding principal does not exists' do
  # describe 'attemps to save the firm' do
  # it 'always fail' do
  # end
  # it 'remove cached questions for the firm' do
  # end
  # end
  # describe 'if within the cache timeout' do
  # it 'the saved questions exist in the cache' do
  # end
  # end
  # describe 'if after the cache timeout' do
  # it 'the saved questions do not exist in the cache' do
  # end
  # end
  # end
end
