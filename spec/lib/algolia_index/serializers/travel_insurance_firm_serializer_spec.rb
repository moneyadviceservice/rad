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
          phone: firm.main_office.telephone_number.delete(' '),
          telephone_quote: firm.service_detail.offers_telephone_quote
        },
        opening_times: {
          week_days: {
            opens: firm.main_office.opening_time.weekday_opening_time.present?,
            open_time: firm.main_office.opening_time.weekday_opening_time.to_s(:time),
            close_time: firm.main_office.opening_time.weekday_closing_time.to_s(:time)
          },
          saturdays: {
            opens: firm.main_office.opening_time.saturday_opening_time.present?,
            open_time: firm.main_office.opening_time.saturday_opening_time&.to_s(:time),
            close_time: firm.main_office.opening_time.saturday_closing_time&.to_s(:time)
          },
          sundays: {
            opens: firm.main_office.opening_time.sunday_opening_time.present?,
            open_time: firm.main_office.opening_time.sunday_opening_time&.to_s(:time),
            close_time: firm.main_office.opening_time.sunday_closing_time&.to_s(:time)
          }
        },
        overview: {
          coronavirus_cancellation_cover: true,
          coronavirus_medical_expense: true,
          cruise_cover: true,
          medical_conditions_cover: {
            most_conditions_covered: false,
            specialises_in: 'cancer'
          },
          medical_equipment_cover: {
            cover_amount: 1000,
            offers_cover: true
          },
          medical_screening_company: 'verisik'
        }
      }.with_indifferent_access
    end

    it { expect(serialized).to eq(expected_json) }
  end
end
