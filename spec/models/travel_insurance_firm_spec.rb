RSpec.describe TravelInsuranceFirm, type: :model do
  it { should belong_to :principal }
  it { should belong_to(:parent).class_name(TravelInsuranceFirm) }
  it { should have_one :office }
  it { should have_one :medical_specialism }
  it { should have_one :service_detail }
  it { should have_many :trip_covers }
  it { should accept_nested_attributes_for :trip_covers }
  it { should accept_nested_attributes_for :medical_specialism }
  it { should accept_nested_attributes_for :service_detail }

  subject(:firm) { build(:travel_insurance_firm) }

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

  describe 'after_commit' do
    it 'saving a new firm calls notify_indexer' do
      firm = FactoryBot.build(:travel_insurance_firm, with_associated_principle: true)
      expect(firm).to receive(:notify_indexer)
      firm.save
    end

    it 'updating a firm calls notify_indexer' do
      firm = FactoryBot.create(:travel_insurance_firm, with_associated_principle: true)
      expect(firm).to receive(:notify_indexer)
      firm.update(registered_name: 'A new name')
    end

    it 'destroying a firm calls notify_indexer' do
      firm = FactoryBot.create(:travel_insurance_firm, with_associated_principle: true)
      expect(firm).to receive(:notify_indexer)
      firm.destroy
    end
  end

  describe '#notify_indexer' do
    context 'when travel firm is completed' do
      let!(:travel_firm) { create(:travel_insurance_firm, completed_firm: true) }

      it 'notifies the indexer that the travel_insurance_firm has changed' do
        expect(UpdateAlgoliaIndexJob).to receive(:perform_later)
          .with('TravelInsuranceFirm', travel_firm.id)

        travel_firm.notify_indexer
      end
    end

    context 'when travel firm is not complete' do
      let!(:travel_firm) { create(:travel_insurance_firm, with_associated_principle: true) }

      it 'notifies the indexer that the travel_insurance_firm has changed' do
        expect(UpdateAlgoliaIndexJob).to receive(:perform_later)
          .with('TravelInsuranceFirm', travel_firm.id).never

        travel_firm.notify_indexer
      end
    end
  end

  describe '#allowed_to_add_trading_names?' do
    context 'when firm has no trading names' do
      let(:travel_firm) { build(:travel_insurance_firm) }
      it 'returns true' do
        expect(travel_firm.can_add_more_trading_names?).to eq true
      end
    end

    context 'when firm has 2 or more trading names' do
      let!(:travel_firm) { create(:travel_insurance_firm, with_associated_principle: true) }
      let!(:travel_firm_1) { create(:travel_insurance_firm, parent: travel_firm, fca_number: travel_firm.fca_number) }
      let!(:travel_firm_2) { create(:travel_insurance_firm, parent: travel_firm, fca_number: travel_firm.fca_number) }

      it 'returns false ' do
        expect(travel_firm.reload.can_add_more_trading_names?).to eq false
      end
    end
  end

  describe '#publishable?' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, with_associated_principle: true) }
    subject { firm.publishable? }

    context 'when the firm is valid and complete' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      it { is_expected.to be_truthy }
    end

    context 'when the firm has no main office' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      before { allow(firm).to receive(:office).and_return(nil) }

      it { is_expected.to be_falsey }
    end

    context 'when the firm is not cover_and_service_complete?' do
      let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
      before { allow(firm).to receive(:cover_and_service_complete?).and_return(false) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#cover_and_service_complete?' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }

    it 'returns true when everything is complete' do
      expect(firm.cover_and_service_complete?).to eq true
    end

    context 'when service_detail is not present' do
      it 'returns false when service_detail is not present' do
        allow(firm).to receive(:service_detail).and_return(nil)
        expect(firm.cover_and_service_complete?).to eq false
      end
    end

    context 'when medical_specialism is not present' do
      it 'returns false when medical_specialism is not present' do
        allow(firm).to receive(:medical_specialism).and_return(nil)
        expect(firm.cover_and_service_complete?).to eq false
      end
    end

    context 'when trip_covers is not complete' do
      it 'returns false' do
        allow(firm).to receive(:trip_covers).and_return([])
        expect(firm.cover_and_service_complete?).to eq false
      end
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
