RSpec.describe AlgoliaIndex::FirmSerializer do
  describe 'json' do
    subject(:serialized) { JSON.parse(described_class.new(firm).to_json) }

    let(:firm) { FactoryBot.create(:firm) }
    let(:expected_json) do
      {
        id: firm.id,
        registered_name: firm.registered_name,
        postcode_searchable: firm.postcode_searchable?,
        telephone_number: firm.main_office.try(:telephone_number),
        website_address: firm.main_office.try(:website) || firm.website_address,
        email_address: firm.main_office.try(:email_address),
        free_initial_meeting: firm.free_initial_meeting,
        minimum_fixed_fee: firm.minimum_fixed_fee,
        retirement_income_products_flag: firm.retirement_income_products_flag,
        pension_transfer_flag: firm.pension_transfer_flag,
        long_term_care_flag: firm.long_term_care_flag,
        equity_release_flag: firm.equity_release_flag,
        inheritance_tax_and_estate_planning_flag: firm.inheritance_tax_and_estate_planning_flag,
        wills_and_probate_flag: firm.wills_and_probate_flag,
        other_advice_methods: firm.other_advice_method_ids,
        investment_sizes: firm.investment_size_ids,
        in_person_advice_methods: firm.in_person_advice_method_ids,
        adviser_qualification_ids: firm.qualification_ids,
        adviser_accreditation_ids: firm.accreditation_ids,
        ethical_investing_flag: firm.ethical_investing_flag,
        sharia_investing_flag: firm.sharia_investing_flag,
        workplace_financial_advice_flag: firm.workplace_financial_advice_flag,
        non_uk_residents_flag: firm.non_uk_residents_flag,
        languages: firm.languages,
        total_offices: firm.offices.geocoded.count,
        total_advisers: firm.advisers.geocoded.count
      }.with_indifferent_access
    end

    it { expect(serialized).to eq(expected_json) }
  end
end
