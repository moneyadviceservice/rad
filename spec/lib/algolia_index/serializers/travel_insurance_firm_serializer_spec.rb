RSpec.describe AlgoliaIndex::TravelInsuranceFirmSerializer do
  describe 'json' do
    subject(:serialized) { JSON.parse(described_class.new(firm).to_json) }

    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
    let(:expected_json) do
      {
        objectID: firm.id,
        company: firm.registered_name,
        offering_ids: firm.trip_covers.pluck(:id),
        online: {
          website: firm.main_office.website,
          email: firm.main_office.email_address,
          phone: firm.main_office.telephone_number,
          telephone_quote: firm.service_detail.offers_telephone_quote
        },
        opening_times: {
          week_days: {
            open_time: firm.main_office.opening_time.weekday_opening_time.to_s(:time),
            close_time: firm.main_office.opening_time.weekday_closing_time.to_s(:time)
          },
          saturdays: {
            open_time: firm.main_office.opening_time.saturday_opening_time&.to_s(:time),
            close_time: firm.main_office.opening_time.saturday_closing_time&.to_s(:time)
          },
          sundays: {
            open_time: firm.main_office.opening_time.sunday_opening_time&.to_s(:time),
            close_time: firm.main_office.opening_time.sunday_closing_time&.to_s(:time)
          }
        },
        overview: [
          {
            heading: 'Medical conditions covered',
            text: 'specialises in Cancer'
          },
          {
            heading: 'Offers Coronavirus cover for medical expenses',
            text: 'Yes'
          },
          {
            heading: 'Offers Coronavirus cover if trip cancelled',
            text: 'Yes'
          },
          {
            heading: 'Medical equipment cover',
            text: 'yes up to £1,000'
          },
          {
            heading: 'Cruise cover',
            text: 'Yes'
          },
          {
            heading: 'Medical Screening company used',
            text: 'Verisk (formerly Healix Risk Rating)'
          }
        ]
      }.with_indifferent_access
    end

    it { expect(serialized).to eq(expected_json) }
  end
end
