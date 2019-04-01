RSpec.describe AlgoliaIndex::TestSeeds do
  describe '.generate' do
    subject(:generate) { described_class.new.generate }

    let(:index_advisers) { instance_double(::Algolia::Index) }
    let(:index_offices) { instance_double(::Algolia::Index) }

    let(:seed_advisers) do
      [{ _geoloc: { lat: 51.51193, lng: -0.095115 },
         objectID: 1,
         name: 'Caitlyn Kohler',
         postcode: 'EC4V 4AY',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:             { id: 1,
                             registered_name: 'Test Firm Central London',
                             postcode_searchable: true,
                             telephone_number: '07111 333 135',
                             website_address: 'http://example.net/offices/135',
                             email_address: 'office135@example.org',
                             free_initial_meeting: true,
                             minimum_fixed_fee: 0,
                             retirement_income_products: true,
                             pension_transfer: false,
                             options_when_paying_for_care: false,
                             equity_release: true,
                             inheritance_tax_planning: false,
                             wills_and_probate: false,
                             other_advice_methods: [],
                             investment_sizes: [3, 4],
                             in_person_advice_methods: [2],
                             adviser_qualification_ids: [3, 4],
                             adviser_accreditation_ids: [1, 2],
                             ethical_investing_flag: false,
                             sharia_investing_flag: false,
                             workplace_financial_advice_flag: false,
                             non_uk_residents_flag: false,
                             languages: [],
                             total_offices: 2,
                             total_advisers: 2 } },
       { _geoloc: { lat: 51.51807, lng: -0.10852 },
         objectID: 2,
         name: 'Addison Klocko',
         postcode: 'EC1N 2TD',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 1,
                          registered_name: 'Test Firm Central London',
                          postcode_searchable: true,
                          telephone_number: '07111 333 135',
                          website_address: 'http://example.net/offices/135',
                          email_address: 'office135@example.org',
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: true,
                          pension_transfer: false,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [2],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 2,
                          total_advisers: 2 } },
       { _geoloc: { lat: 51.510643, lng: -0.052898 },
         objectID: 3,
         name: 'Ms. Wyman Sawayn',
         postcode: 'E1 0AE',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 2,
                          registered_name: 'Test Firm East London',
                          postcode_searchable: true,
                          telephone_number: '07111 333 417',
                          website_address: 'http://example.net/offices/417',
                          email_address: 'office417@example.com',
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: true,
                          pension_transfer: false,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [2],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 1,
                          total_advisers: 2 } },
       { _geoloc: { lat: 51.510643, lng: -0.052898 },
         objectID: 4,
         name: 'Eliseo Walker',
         postcode: 'E1 0AE',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 2,
                          registered_name: 'Test Firm East London',
                          postcode_searchable: true,
                          telephone_number: '07111 333 417',
                          website_address: 'http://example.net/offices/417',
                          email_address: 'office417@example.com',
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: true,
                          pension_transfer: false,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [2],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 1,
                          total_advisers: 2 } },
       { _geoloc: { lat: 50.826334, lng: -0.140818 },
         objectID: 5,
         name: 'Madge Schaden',
         postcode: 'BN1 1AA',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 3,
                          registered_name: 'Test Firm Brighton',
                          postcode_searchable: true,
                          telephone_number: nil,
                          website_address: nil,
                          email_address: nil,
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: true,
                          pension_transfer: false,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [2],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 0,
                          total_advisers: 1 } },
       { _geoloc: { lat: 51.51807, lng: -0.10852 },
         objectID: 6,
         name: 'Harrison Boehm',
         postcode: 'EC1N 2TD',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 4,
                          registered_name: 'Test Firm Remote 1',
                          postcode_searchable: false,
                          telephone_number: nil,
                          website_address: nil,
                          email_address: nil,
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: true,
                          pension_transfer: false,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [1, 2],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 0,
                          total_advisers: 1 } },
       { _geoloc: { lat: 51.51807, lng: -0.10852 },
         objectID: 7,
         name: 'Chad Turcotte',
         postcode: 'EC1N 2TD',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 5,
                          registered_name: 'Test Firm Remote 2',
                          postcode_searchable: false,
                          telephone_number: nil,
                          website_address: nil,
                          email_address: nil,
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: true,
                          pension_transfer: false,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [1, 2],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 0,
                          total_advisers: 1 } },
       { _geoloc: { lat: 51.51807, lng: -0.10852 },
         objectID: 8,
         name: 'Don Pollich',
         postcode: 'EC1N 2TD',
         travel_distance: 100,
         qualification_ids: [3, 4],
         accreditation_ids: [1, 2],
         firm:          { id: 6,
                          registered_name: 'Test Firm Remote 3',
                          postcode_searchable: false,
                          telephone_number: nil,
                          website_address: nil,
                          email_address: nil,
                          free_initial_meeting: true,
                          minimum_fixed_fee: 0,
                          retirement_income_products: false,
                          pension_transfer: true,
                          options_when_paying_for_care: false,
                          equity_release: true,
                          inheritance_tax_planning: false,
                          wills_and_probate: false,
                          other_advice_methods: [1, 2],
                          investment_sizes: [3, 4],
                          in_person_advice_methods: [],
                          adviser_qualification_ids: [3, 4],
                          adviser_accreditation_ids: [1, 2],
                          ethical_investing_flag: false,
                          sharia_investing_flag: false,
                          workplace_financial_advice_flag: false,
                          non_uk_residents_flag: false,
                          languages: [],
                          total_offices: 0,
                          total_advisers: 1 } }]
    end

    let(:seed_offices) do
      [{ _geoloc: { lat: 51.51193, lng: -0.095115 },
         objectID: 1,
         firm_id: 1,
         address_line_one: '493 Tremblay Pass',
         address_line_two: 'Apt. 746',
         address_town: 'Kaseyview',
         address_county: 'Alaska',
         address_postcode: 'EC4V 4AY',
         email_address: 'office135@example.org',
         telephone_number: '07111 333 135',
         disabled_access: true,
         website: 'http://example.net/offices/135' },
       { _geoloc: { lat: 51.51807, lng: -0.10852 },
         objectID: 2,
         firm_id: 1,
         address_line_one: '49759 Wyman Parkways',
         address_line_two: 'Suite 863',
         address_town: 'Devanhaven',
         address_county: 'Illinois',
         address_postcode: 'EC1N 2TD',
         email_address: 'office789@example.org',
         telephone_number: '07111 333 789',
         disabled_access: false,
         website: 'http://example.net/offices/789' },
       { _geoloc: { lat: 51.510643, lng: -0.052898 },
         objectID: 3,
         firm_id: 2,
         address_line_one: '57328 Kiehn Mountain',
         address_line_two: 'Suite 507',
         address_town: 'New Roderick',
         address_county: 'Vermont',
         address_postcode: 'E1 0AE',
         email_address: 'office417@example.com',
         telephone_number: '07111 333 417',
         disabled_access: false,
         website: 'http://example.net/offices/417' }]
    end

    before do
      allow(::Algolia::Index).to receive(:new)
        .with('firm-advisers-test')
        .and_return(index_advisers)

      allow(::Algolia::Index).to receive(:new)
        .with('firm-offices-test')
        .and_return(index_offices)

      stubbed_geocodes = {
        'EC4V 4AY': [51.5119304, -0.0951152],
        'EC1N 2TD': [51.5180697, -0.1085203],
        'E1 0AE': [51.5106429, -0.0528977],
        'BN1 1AA': [50.8263337, -0.1408184]
      }

      stubbed_geocodes.each do |postcode, coordinates|
        allow(Geocoder).to receive(:coordinates)
          .with("#{postcode}, UK").and_return(coordinates)
      end
    end

    before do
      load Rails.root.join('db', 'seeds.rb')
    end

    it 'refreshes the indices', :aggregate_failures do
      expect(index_advisers).to receive(:clear_index)
      expect(index_offices).to receive(:clear_index)

      expect(index_advisers).to receive(:add_objects).with(seed_advisers)
      expect(index_offices).to receive(:add_objects).with(seed_offices)

      generate
    end
  end
end
