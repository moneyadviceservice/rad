RSpec.describe AlgoliaIndex::OfficeSerializer do
  describe 'json' do
    subject(:serialized) { JSON.parse(described_class.new(office).to_json) }

    let(:expected_json) do
      {
        _geoloc: {
          lat: office.latitude,
          lng: office.longitude
        },
        objectID: office.id,
        firm_id: office.officeable_id,
        firm_type: firm_type,
        address_line_one: office.address_line_one,
        address_line_two: office.address_line_two,
        address_town: office.address_town,
        address_county: office.address_county,
        address_postcode: office.address_postcode,
        email_address: office.email_address,
        telephone_number: office.telephone_number,
        disabled_access: office.disabled_access,
        website: office.website
      }.with_indifferent_access
    end

    context 'retirement advise firm' do
      let(:firm_type) { 'retirement_firm' }
      let(:office) { FactoryBot.create(:office, officeable: FactoryBot.build(:firm)) }

      it { expect(serialized).to eq(expected_json) }
    end

    context 'travel insurance firm' do
      let(:firm_type) { 'travel_insurance_firm' }
      let(:travel_insurance_firm) { FactoryBot.build(:travel_insurance_firm, create_associated_principle: true) }
      let(:office) { FactoryBot.create(:office, officeable: travel_insurance_firm) }

      it { expect(serialized).to eq(expected_json) }
    end
  end
end
