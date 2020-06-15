RSpec.describe PrincipalRegistrationStatus do
  describe 'already_signed_up_for_this_service?' do
    context 'when principal has a retirement advice firm' do
      let(:principal) { FactoryBot.create(:principal) }

      it 'returns true if the principal has a firm matching the registration type' do
        status = described_class.new(
          principal.email_address,
          'retirement_advice_registrations'
        )

        expect(status.already_signed_up_for_this_service?).to eq true
      end

      it 'returns false if the principal does not have a firm matching the registration type' do
        status = described_class.new(
          principal.email_address,
          'travel_insurance_registrations'
        )

        expect(status.already_signed_up_for_this_service?).to eq false
      end
    end

    context 'when principal has a travel insurance firm' do
      let(:principal) do
        principal = FactoryBot.create(:principal, manually_build_firms: true)
        FactoryBot.create(:travel_insurance_firm, fca_number: principal.fca_number)
        principal
      end

      it 'returns true if the principal has a firm matching the registration type' do
        status = described_class.new(
          principal.email_address,
          'travel_insurance_registrations'
        )

        expect(status.already_signed_up_for_this_service?).to eq true
      end

      it 'returns false if the principal does not have a firm matching the registration type' do
        status = described_class.new(
          principal.email_address,
          'retirement_advice_registrations'
        )

        expect(status.already_signed_up_for_this_service?).to eq false
      end
    end
  end

  describe 'existing_principal?' do
    context 'when given the email of an existing principal' do
      let(:principal) { FactoryBot.create(:principal) }

      it 'returns true' do
        status = described_class.new(
          principal.email_address,
          'retirement_advice_registrations'
        )

        expect(status.existing_principal?).to eq true
      end
    end

    context 'when given the email of a non-existing principal' do
      it 'returns false' do
        status = described_class.new(
          'some_rando_email@test.com',
          'retirement_advice_registrations'
        )

        expect(status.existing_principal?).to eq false
      end
    end
  end
end
