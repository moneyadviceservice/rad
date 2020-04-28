RSpec.describe TravelInsurance::MedicalConditionsQuestionaireForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when all questions are answered and valid' do
    let(:params) do
      {
        metastatic_breast_cancer_question: '1',
        ulceritive_colitis_and_anaemia_question: '1',
        heart_attack_with_hbp_and_high_cholesterol_question: '1',
        copd_with_respiratory_infection_question: '1',
        motor_neurone_disease_question: '1',
        hodgkin_lymphoma_question: '1',
        acute_myeloid_leukaemia_question: '1',
        guillain_barre_syndrome_question: '1',
        heart_failure_and_arrhytmia_question: '1',
        stroke_with_hbp_question: '1',
        peripheral_vascular_disease_question: '1',
        schizophrenia_question: '1',
        lupus_question: '1',
        sickle_cell_and_renal_question: '1',
        sub_arachnoid_haemorrhage_and_epilepsy_question: '1'
      }
    end

    it { is_expected.to be_valid }
  end

  context 'when not all questions are answered' do
    let(:params) { { metastatic_breast_cancer_question: '1' } }
    it { is_expected.not_to be_valid }
  end
end
