RSpec.describe AlgoliaIndex::AdviserSerializer do
  describe 'json' do
    subject(:serialized) { JSON.parse(described_class.new(adviser).to_json) }

    let(:adviser) { FactoryBot.create(:advisers_retirement_firm) }
    let(:firm) { adviser.firm }
    let(:expected_json) do
      {
        _geoloc: {
          lat: adviser.latitude,
          lng: adviser.longitude
        },
        objectID: adviser.id,
        name: adviser.name,
        postcode: adviser.postcode,
        travel_distance: adviser.travel_distance,
        qualification_ids: adviser.qualification_ids,
        accreditation_ids: adviser.accreditation_ids,
        firm: AlgoliaIndex::FirmSerializer.new(firm).as_json
      }.with_indifferent_access
    end

    it { expect(serialized).to eq(expected_json) }
  end
end
