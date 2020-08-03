RSpec.describe MedicalSpecialism, type: :model do
  it { should belong_to :travel_insurance_firm }

  describe 'validations' do
    describe 'likely_not_cover_medical_condition' do
      context 'when likely_not_cover_medical_condition_select is true' do
        before { allow(subject).to receive(:likely_not_cover_medical_condition_select).and_return(true) }

        it 'validates presence of likely_not_cover_medical_condition' do
          is_expected.to validate_presence_of(:likely_not_cover_medical_condition)
        end
      end

      context 'when likely_not_cover_medical_condition_select is not set' do
        it 'does not validate presence of likely_not_cover_medical_condition' do
          is_expected.not_to validate_presence_of(:likely_not_cover_medical_condition)
        end
      end
    end

    describe 'specialised_medical_conditions_cover' do
      context 'when specialised_medical_conditions_covers_all is false' do
        before { allow(subject).to receive(:specialised_medical_conditions_covers_all).and_return(false) }

        it 'validates presence of specialised_medical_conditions_cover' do
          is_expected.to validate_presence_of(:specialised_medical_conditions_cover)
        end
      end

      context 'when specialised_medical_conditions_covers_all is set to true' do
        before { allow(subject).to receive(:specialised_medical_conditions_covers_all).and_return(true) }

        it 'does not validate presence of specialised_medical_conditions_cover' do
          is_expected.not_to validate_presence_of(:specialised_medical_conditions_cover)
        end
      end
    end
  end

  describe '#completed?' do
    context 'when all required fields are present' do
      let(:medical_specialism) { create(:medical_specialism) }
      it { expect(medical_specialism.completed?).to eq true }
    end

    context 'when not all required fields are present' do
      let(:medical_specialism) { create(:medical_specialism, cover_undergoing_treatment: nil) }
      it { expect(medical_specialism.completed?).to eq false }
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
