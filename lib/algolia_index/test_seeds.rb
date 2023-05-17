# TODO: this does not appear to be used. Review and delete.
module AlgoliaIndex
  class TestSeeds # rubocop:disable Metrics/ClassLength
    ADVICE_TYPES_ATTRIBUTES = %i[
      retirement_income_products_flag
      pension_transfer_flag
      long_term_care_flag
      equity_release_flag
      inheritance_tax_and_estate_planning_flag
      wills_and_probate_flag
    ].freeze

    def generate
      generate_advisers_and_offices
      refresh_indices!
    end

    private

    def refresh_indices!
      indexed_advisers = ::Algolia::Index.new('firm-advisers-test')
      indexed_offices = ::Algolia::Index.new('firm-offices-test')

      indexed_advisers.clear_index
      indexed_offices.clear_index

      indexed_advisers.add_objects(@advisers)
      indexed_offices.add_objects(@offices)
    end

    def create_firm(attributes)
      fca_number = rand(100_000..999_999)
      firm = ::Firm.new(
        fca_number: fca_number,
        registered_name: attributes[:registered_name]
      )
      firm.save!(validate: false)
      create_principal(fca_number)

      # rubocop:disable Rails/SkipsModelValidations
      firm.update_attribute(:id, attributes[:id])
      # rubocop:enable Rails/SkipsModelValidations
      attributes = firm_base_attributes.merge(attributes.except(:id))
      firm.update!(attributes)
      firm.reload
    end

    def create_adviser_for_firm(attributes)
      attributes = adviser_base_attributes.merge(attributes)
      attributes[:reference_number] = "AAA#{rand(10_000..99_999)}"

      lat, lng = Geocoder.coordinates("#{attributes[:postcode]}, UK")
      attributes[:latitude] = lat
      attributes[:longitude] = lng

      create_lookup_adviser(attributes[:reference_number], attributes[:name])

      ::Adviser.create!(attributes)
    end

    def create_office_for_firm(attributes = {})
      lat, lng = Geocoder.coordinates("#{attributes[:address_postcode]}, UK")
      attributes[:latitude] = lat
      attributes[:longitude] = lng

      ::Office.create!(attributes)
    end

    def create_lookup_adviser(reference_number, name)
      ::Lookup::Adviser.create!(
        reference_number: reference_number,
        name: name
      )
    end

    def create_principal(fca_number)
      first_name = Faker::Name.first_name
      ::Principal.create!(
        fca_number: fca_number,
        first_name: first_name,
        last_name: Faker::Name.last_name,
        email_address: Faker::Internet.email(first_name),
        job_title: Faker::Name.title,
        telephone_number: '07111 333 222',
        confirmed_disclaimer: true
      )
    end

    def create_firm_with_in_person_advice(attributes)
      create_firm(
        attributes.merge(
          in_person_advice_methods: ::InPersonAdviceMethod.where(id: [2])
        )
      )
    end

    def create_firm_with_remote_advice(attributes)
      create_firm(
        attributes.merge(
          other_advice_methods: ::OtherAdviceMethod.where(id: [1, 2])
        )
      )
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def generate_advisers_and_offices
      firm1 = create_firm_with_in_person_advice(
        id: 1,
        registered_name: 'Test Firm Central London',
        website_address: 'http://example.net/test-firm-central-london',
        retirement_income_products_flag: true,
        pension_transfer_flag: false,
        equity_release_flag: true,
        investment_size_ids: [1],
        languages: ['ita'],
        workplace_financial_advice_flag: true
      )
      firm2 = create_firm_with_in_person_advice(
        id: 2,
        registered_name: 'Test Firm East London',
        website_address: 'http://example.net/test-firm-east-london',
        retirement_income_products_flag: true,
        pension_transfer_flag: false,
        equity_release_flag: true,
        investment_size_ids: [2],
        languages: %w[ita fra]
      )
      firm3 = create_firm_with_in_person_advice(
        id: 3,
        registered_name: 'Test Firm Brighton',
        website_address: nil,
        retirement_income_products_flag: true,
        pension_transfer_flag: false,
        equity_release_flag: true,
        investment_size_ids: [3]
      )

      firm4 = create_firm_with_remote_advice(
        id: 4,
        registered_name: 'Test Firm Remote 1',
        website_address: nil,
        retirement_income_products_flag: true,
        pension_transfer_flag: false,
        equity_release_flag: true,
        investment_size_ids: [4]
      )
      firm5 = create_firm_with_remote_advice(
        id: 5,
        registered_name: 'Test Firm Remote 2',
        website_address: nil,
        retirement_income_products_flag: true,
        pension_transfer_flag: false,
        equity_release_flag: true,
        investment_size_ids: [2, 4],
        workplace_financial_advice_flag: true
      )
      firm6 = create_firm_with_remote_advice(
        id: 6,
        registered_name: 'Test Firm Remote 3',
        website_address: nil,
        retirement_income_products_flag: false,
        pension_transfer_flag: true,
        equity_release_flag: true,
        investment_size_ids: [4]
      )

      adviser1 = create_adviser_for_firm(
        id: 1,
        firm: firm1,
        name: 'Caitlyn Kohler',
        postcode: 'EC4V 4AY',
        accreditation_ids: [1, 2],
        qualification_ids: [3, 4]
      )
      adviser2 = create_adviser_for_firm(
        id: 2,
        firm: firm1,
        name: 'Addison Klocko',
        postcode: 'EC1N 2TD'
      )
      adviser3 = create_adviser_for_firm(
        id: 3,
        firm: firm2,
        name: 'Ms. Wyman Sawayn',
        postcode: 'E1 0AE',
        accreditation_ids: [1],
        qualification_ids: [3]
      )
      adviser4 = create_adviser_for_firm(
        id: 4,
        firm: firm2,
        name: 'Eliseo Walker',
        postcode: 'E1 0AE'
      )
      adviser5 = create_adviser_for_firm(
        id: 5,
        firm: firm3,
        name: 'Madge Schaden',
        postcode: 'BN1 1AA'
      )
      adviser6 = create_adviser_for_firm(
        id: 6,
        firm: firm4,
        name: 'Harrison Boehm',
        postcode: 'EC1N 2TD'
      )
      adviser7 = create_adviser_for_firm(
        id: 7,
        firm: firm5,
        name: 'Chad Turcotte',
        postcode: 'EC1N 2TD'
      )
      adviser8 = create_adviser_for_firm(
        id: 8,
        firm: firm6,
        name: 'Don Pollich',
        postcode: 'EC1N 2TD'
      )

      in_person_advisers = [adviser1, adviser2, adviser3, adviser4, adviser5]
      remote_advisers = [adviser6, adviser7, adviser8]

      all_advisers = (in_person_advisers + remote_advisers)

      office1 = create_office_for_firm(
        id: 1,
        officeable: firm1,
        address_line_one: '493 Tremblay Pass',
        address_line_two: 'Apt. 746',
        address_town: 'Kaseyview',
        address_county: 'Alaska',
        address_postcode: 'EC4V 4AY',
        email_address: 'office135@example.org',
        telephone_number: '07111 333 135',
        disabled_access: true,
        website: 'http://example.net/offices/135'
      )
      office2 = create_office_for_firm(
        id: 2,
        officeable: firm1,
        address_line_one: '49759 Wyman Parkways',
        address_line_two: 'Suite 863',
        address_town: 'Devanhaven',
        address_county: 'Illinois',
        address_postcode: 'EC1N 2TD',
        email_address: 'office789@example.org',
        telephone_number: '07111 333 789',
        disabled_access: false,
        website: 'http://example.net/offices/789'
      )
      office3 = create_office_for_firm(
        id: 3,
        officeable: firm2,
        address_line_one: '57328 Kiehn Mountain',
        address_line_two: 'Suite 507',
        address_town: 'New Roderick',
        address_county: 'Vermont',
        address_postcode: 'E1 0AE',
        email_address: 'office417@example.com',
        telephone_number: '07111 333 417',
        disabled_access: false,
        website: 'http://example.net/offices/417'
      )

      all_offices = [office1, office2, office3]

      all_advisers.each(&:reload)

      @advisers = all_advisers.map do |adviser|
        AlgoliaIndex::AdviserSerializer.new(adviser).as_json
      end

      @offices = all_offices.map do |office|
        AlgoliaIndex::OfficeSerializer.new(office).as_json
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def firm_base_attributes
      {
        free_initial_meeting: true,
        initial_meeting_duration: ::InitialMeetingDuration.find(1),
        initial_advice_fee_structures: ::InitialAdviceFeeStructure.where(id: [1]), # rubocop:disable Layout/LineLength
        ongoing_advice_fee_structures: ::OngoingAdviceFeeStructure.where(id: [2]), # rubocop:disable Layout/LineLength
        allowed_payment_methods: ::AllowedPaymentMethod.where(id: [2]),
        **ADVICE_TYPES_ATTRIBUTES.zip(
          Array.new(ADVICE_TYPES_ATTRIBUTES.size, false)
        ).to_h
      }
    end

    def adviser_base_attributes
      {
        postcode: 'EC1N 2TD',
        travel_distance: 100
      }
    end
  end
end
