RSpec.describe TravelInsuranceFirm, type: :model do
  test_question_answers = [
    [:covered_by_ombudsman_question, 'true'],
    [:risk_profile_approach_question, 'bespoke'],
    [:covers_medical_condition_question, 'one_specific'],
    [:metastatic_breast_cancer_question, 'false'],
    [:ulceritive_colitis_and_anaemia_question, 'true'],
    [:heart_attack_with_hbp_and_high_cholesterol_question, 'false'],
    [:copd_with_respiratory_infection_question, 'true'],
    [:motor_neurone_disease_question, 'true'],
    [:hodgkin_lymphoma_question, 'false'],
    [:acute_myeloid_leukaemia_question, 'false'],
    [:guillain_barre_syndrome_question, 'true'],
    [:heart_failure_and_arrhytmia_question, 'false'],
    [:stroke_with_hbp_question, 'false'],
    [:peripheral_vascular_disease_question, 'true'],
    [:schizophrenia_question, 'true'],
    [:lupus_question, 'true'],
    [:sickle_cell_and_renal_question, 'false'],
    [:sub_arachnoid_haemorrhage_and_epilepsy_question, 'false']
  ]
  test_questions = Hash[test_question_answers.sample(rand(1..18)).map { |key, value| [key, value] }]

  describe "the question answers: #{test_questions} are cached before saving a firm" do
    let(:travel_firm) do
      existing_principal = create(:principal, manually_build_firms: true)
      TravelInsuranceFirm.cache_question_answers(test_questions.merge(fca_number: existing_principal.fca_number, email: existing_principal.email_address))
      TravelInsuranceFirm.create(fca_number: existing_principal.fca_number, registered_name: 'Test Travel Firm')
    end
    it 'will add the cached  to the saved firm' do
      travel_firm.save
      test_questions.each do |question_answer|
        expect(travel_firm[question_answer[0].to_sym].to_s).to eq question_answer[1]
      end
    end
  end
  # describe 'cached question ansewers not set directly on the model' do
  # TravelInsuranceFirm.cache_question_answers(fca_number: firm.fca_number, email: principal.email_address, covered_by_ombudsman_question: 'true')
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
