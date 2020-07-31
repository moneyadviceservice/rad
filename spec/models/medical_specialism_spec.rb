RSpec.describe MedicalSpecialism, type: :model do
  it { should belong_to :travel_insurance_firm }

  describe 'validations' do
    before { allow(subject).to receive(:likely_not_cover_medical_condition_select).and_return(true) }

    it 'validates presence of likely_not_cover_medical_condition if likely_not_cover_medical_condition_select is true' do
      is_expected.to validate_presence_of(:likely_not_cover_medical_condition)
    end
  end

  describe '#completed?' do
    context 'when all required fields are present' do
      let(:medical_specialism) { create(:medical_specialism) }

      it 'returns true' do
        expect(medical_specialism.completed?).to eq true
      end
    end

    context 'when not all required fields are present' do
      let(:medical_specialism) { create(:medical_specialism, cover_undergoing_treatment: nil) }

      it 'returns false' do
        expect(medical_specialism.completed?).to eq false
      end
    end
  end

  describe 'before_save' do
    let(:medical_specialism) { create(:medical_specialism) }

    it 'clears specialised_medical_conditions_cover when specialised_medical_conditions_covers_all is false' do
      medical_specialism.specialised_medical_conditions_covers_all = true
      medical_specialism.save

      expect(medical_specialism.specialised_medical_conditions_cover).to be_nil
      expect(medical_specialism.likely_not_cover_medical_condition).not_to be_nil
    end

    it 'clears likely_not_cover_medical_condition when likely_not_cover_medical_condition_select is false' do
      medical_specialism.likely_not_cover_medical_condition_select = false
      medical_specialism.save

      expect(medical_specialism.specialised_medical_conditions_cover).not_to be_nil
      expect(medical_specialism.likely_not_cover_medical_condition).to be_nil
    end

    it 'medical conditions selects are not cleared if not set to false' do
      medical_specialism.terminal_prognosis_cover = false
      medical_specialism.save

      expect(medical_specialism.specialised_medical_conditions_cover).not_to be_nil
      expect(medical_specialism.likely_not_cover_medical_condition).not_to be_nil
    end
  end
end
