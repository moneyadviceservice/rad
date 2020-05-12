RSpec.describe TravelInsurance::MedicalConditionsQuestionaireForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when all questions are answered and valid' do
    let(:params) do
      {
        metastatic_breast_cancer_question: 'true',
        ulceritive_colitis_and_anaemia_question: 'true',
        heart_attack_with_hbp_and_high_cholesterol_question: 'true',
        copd_with_respiratory_infection_question: 'true',
        motor_neurone_disease_question: 'true',
        hodgkin_lymphoma_question: 'true',
        acute_myeloid_leukaemia_question: 'true',
        guillain_barre_syndrome_question: 'true',
        heart_failure_and_arrhytmia_question: 'true',
        stroke_with_hbp_question: 'true',
        peripheral_vascular_disease_question: 'true',
        schizophrenia_question: 'true',
        lupus_question: 'true',
        sickle_cell_and_renal_question: 'true',
        sub_arachnoid_haemorrhage_and_epilepsy_question: 'true'
      }
    end

    it { is_expected.to be_valid }
  end

  context 'when not all questions are answered' do
    let(:params) { { metastatic_breast_cancer_question: 'true' } }
    it { is_expected.not_to be_valid }
  end
end
