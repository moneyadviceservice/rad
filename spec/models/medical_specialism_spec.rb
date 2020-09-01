RSpec.describe MedicalSpecialism, type: :model do
  it { should belong_to :travel_insurance_firm }

  it { should validate_inclusion_of(:terminal_prognosis_cover).in?([true, false]) }
  it { should validate_inclusion_of(:will_cover_undergoing_treatment).in?([true, false]) }
  it { should validate_inclusion_of(:will_not_cover_some_medical_conditions).in?([true, false]) }

  describe 'validations' do
    describe 'likely_not_cover_medical_condition' do
      context 'when will_not_cover_some_medical_conditions is true' do
        before { allow(subject).to receive(:will_not_cover_some_medical_conditions).and_return(true) }

        it 'validates presence of likely_not_cover_medical_condition' do
          is_expected.to validate_presence_of(:likely_not_cover_medical_condition)
        end
      end

      context 'when will_not_cover_some_medical_conditions is not set' do
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

    describe 'cover_undergoing_treatment' do
      context 'when will_cover_undergoing_treatment is false' do
        before { allow(subject).to receive(:will_cover_undergoing_treatment).and_return(false) }

        it 'validates presence of cover_undergoing_treatment' do
          is_expected.to validate_presence_of(:cover_undergoing_treatment)
        end
      end

      context 'when will_cover_undergoing_treatment is set to true' do
        before { allow(subject).to receive(:will_cover_undergoing_treatment).and_return(true) }

        it 'does not validate presence of cover_undergoing_treatment' do
          is_expected.not_to validate_presence_of(:cover_undergoing_treatment)
        end
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

    it 'clears likely_not_cover_medical_condition when will_not_cover_some_medical_conditions is false' do
      medical_specialism.will_not_cover_some_medical_conditions = false
      medical_specialism.save

      expect(medical_specialism.specialised_medical_conditions_cover).not_to be_nil
      expect(medical_specialism.likely_not_cover_medical_condition).to be_nil
    end

    it 'clears cover_undergoing_treatment when will_cover_undergoing_treatment is true' do
      medical_specialism.will_cover_undergoing_treatment = true
      medical_specialism.save

      expect(medical_specialism.specialised_medical_conditions_cover).not_to be_nil
      expect(medical_specialism.cover_undergoing_treatment).to be_nil
    end

    it 'medical conditions selects are not cleared if not set to false' do
      medical_specialism.terminal_prognosis_cover = false
      medical_specialism.save

      expect(medical_specialism.specialised_medical_conditions_cover).not_to be_nil
      expect(medical_specialism.likely_not_cover_medical_condition).not_to be_nil
    end
  end
end
