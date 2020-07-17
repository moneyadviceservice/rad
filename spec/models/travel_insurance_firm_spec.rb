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
  test_questions = HashWithIndifferentAccess[test_question_answers.sample(rand(1..18)).map { |key, value| [key, value] }]

  describe '#publishable?' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, with_associated_principle: true) }
    subject { firm.publishable? }

    context 'when the firm is valid, has a main office, medical_specialism, service_details and trip_cover data' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      it { is_expected.to be_truthy }
    end

    context 'when the firm is not valid' do
      let(:firm) { build(:travel_insurance_firm) }

      it { is_expected.to be_falsey }
    end

    context 'when the firm has no main office' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true,) }
      before { allow(firm).to receive(:office).and_return(nil) }

      it { is_expected.to be_falsey }
    end

    context 'when the firm has no medical_specialism' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      before { allow(firm).to receive(:medical_specialism).and_return(nil) }

      it { is_expected.to be_falsey }
    end

    context 'when the firm has no service_detail' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      before { allow(firm).to receive(:service_detail).and_return(nil) }

      it { is_expected.to be_falsey }
    end

    context 'when the firm has no trip_covers' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      before { allow(firm).to receive(:trip_covers).and_return([]) }

      it { is_expected.to be_falsey }
    end
  end

  describe "the question answers: #{test_questions} cached before creating the corresponding firm" do
    let(:travel_firm) do
      existing_principal = create(:principal, manually_build_firms: true)
      TravelInsuranceFirm.cache_question_answers(test_questions.merge(fca_number: existing_principal.fca_number, email: existing_principal.email_address))
      TravelInsuranceFirm.create(fca_number: existing_principal.fca_number, registered_name: 'Test Travel Firm')
    end
    it 'will be transparently added to the newly created firm' do
      test_questions.each do |question_answer|
        expect(travel_firm[question_answer[0].to_sym].to_s).to eq question_answer[1]
      end
    end
  end
  describe 'saved question values' do
    let(:travel_firm) do
      existing_principal = create(:principal, manually_build_firms: true)
      TravelInsuranceFirm.cache_question_answers(fca_number: existing_principal.fca_number, email: existing_principal.email_address, covered_by_ombudsman_question: 'true')
      TravelInsuranceFirm.create(fca_number: existing_principal.fca_number, registered_name: 'Test Travel Firm', covered_by_ombudsman_question: 'false')
    end
    it 'will not be overwritten by the cache' do
      expect(travel_firm[:covered_by_ombudsman_question].to_s).to eq 'false'
    end
  end
  describe 'multiple simultaneos cache requests with the same fca_number but different email address should be independent' do
    let(:travel_firm) do
      create(:principal, fca_number: '111111', email_address: 'first@email.com', manually_build_firms: true)
      TravelInsuranceFirm.cache_question_answers(fca_number: '111111', email: 'first@email.com', covered_by_ombudsman_question: 'true')
      TravelInsuranceFirm.cache_question_answers(fca_number: '111111', email: 'second@email.com', covered_by_ombudsman_question: 'false')

      TravelInsuranceFirm.create(fca_number: '111111', registered_name: 'Test Travel Firm')
    end
    it 'will be transparently added to the newly created firm' do
      expect(travel_firm[:covered_by_ombudsman_question].to_s).to eq 'true'
    end
  end
end
