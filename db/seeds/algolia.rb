module Seeds
  class Algolia
    FIXED_SEEDS = [
      {
        model: InitialMeetingDuration,
        values: ['30 min', '60 min']
      },
      {
        model: InitialAdviceFeeStructure,
        values: ['Hourly fee', 'Fixed fee', 'Other']
      },
      {
        model: OngoingAdviceFeeStructure,
        values: [
          'Hourly fee',
          'Fixed upfront fee',
          'Monthly by direct debit / standing order',
          'Other'
        ]
      },
      {
        model: AllowedPaymentMethod,
        values: ['From their own resources', 'From funds to be invested']
      },
      {
        model: InPersonAdviceMethod,
        values: [
          'At customers home',
          'At firm\'s place of business',
          'At an agreed location'
        ]
      },
      {
        model: OtherAdviceMethod,
        values: [
          'Advice by telephone',
          'Advice online (e.g. by video call / conference / email)'
        ]
      },
      {
        model: InvestmentSize,
        values: [
          'Under £50,000',
          '£50,000 - £99,999',
          '£100,000 - £149,999',
          'Over £150,000'
        ]
      }
    ]

    FIXED_SEEDS.each do |seed|
      seed[:values].each do |value|
        seed[:model].find_or_create_by!(name: value)
      end
    end

    ADVICE_TYPES_ATTRIBUTES = %i[
      retirement_income_products_flag
      pension_transfer_flag
      long_term_care_flag
      equity_release_flag
      inheritance_tax_and_estate_planning_flag
      wills_and_probate_flag
    ].freeze

    FIRM_BASE_ATTRIBUTES = {
      free_initial_meeting: true,
      initial_meeting_duration: InitialMeetingDuration.find(rand(1...2)),
      initial_advice_fee_structures: InitialAdviceFeeStructure.where(id: rand(1..3)),
      ongoing_advice_fee_structures: OngoingAdviceFeeStructure.where(id: rand(1..4)),
      allowed_payment_methods: AllowedPaymentMethod.where(id: rand(1..2)),
      investment_sizes: InvestmentSize.where(id: rand(1..4)),
      **ADVICE_TYPES_ATTRIBUTES.zip(Array.new(ADVICE_TYPES_ATTRIBUTES.size, true)).to_h
    }

    ADVISER_BASE_ATTRIBUTES = {
      postcode: 'EC1N 2TD',
      travel_distance: 100
    }

    def generate
      generate_advisers_and_offices
      byebug
      refresh_indeces!
    end

    private

    def refresh_indeces!
      index_advisers = ::Algolia::Index.new('firm-advisers-test')
      index_offices = ::Algolia::Index.new('firm-offices-test')

      index_advisers.clear_index
      index_offices.clear_index

      index_advisers.add_objects(@advisers)
      index_offices.add_objects(@offices)
    end

    def create_firm(attributes)
      firm = create_lookup_firm(attributes[:registered_name])
      principal = create_principal(firm.fca_number)

      attributes = FIRM_BASE_ATTRIBUTES.merge(attributes)
      attributes.merge!(principal: principal)

      principal.firm.update!(attributes)
      principal.firm.reload
    end

    def create_adviser_for_firm(attributes)
      attributes = ADVISER_BASE_ATTRIBUTES.merge(attributes)
      attributes.merge!(name: Faker::Name.name)
      attributes.merge!(reference_number: "AAA#{rand(10_000..99_999)}")

      latitude, longitude = Geocoder.coordinates("#{attributes[:postcode]}, UK")
      attributes.merge!(latitude: latitude, longitude: longitude)

      create_lookup_adviser(attributes[:reference_number], attributes[:name])

      Adviser.create!(attributes)
    end

    def create_office_for_firm(attributes = {})
      latitude, longitude = Geocoder.coordinates("#{attributes[:postcode]}, UK")
      seed = rand(100..999)
      attributes = {
        address_line_one: Faker::Address.street_address,
        address_line_two: Faker::Address.secondary_address,
        address_town: Faker::Address.city,
        address_county: Faker::Address.state,
        address_postcode: attributes[:postcode],
        email_address: Faker::Internet.safe_email("office#{seed}"),
        telephone_number: "07111 333 #{}",
        disabled_access: [true, false].sample,
        latitude: latitude,
        longitude: longitude,
        website: Faker::Internet.url('example.net', "/offices/#{seed}"),
      }.merge(attributes.except(:postcode))

      Office.create!(attributes)
    end

    def create_lookup_firm(registered_name)
      fca_number = rand(100_000..999_999)
      Lookup::Firm.create!(
        fca_number: fca_number,
        registered_name: registered_name
      )
    end

    def create_lookup_adviser(reference_number, name)
      Lookup::Adviser.create!(
        reference_number: reference_number,
        name: name
      )
    end

    def create_principal(fca_number)
      first_name = Faker::Name.first_name
      Principal.create!(
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
          in_person_advice_methods: InPersonAdviceMethod.where(id: rand(1..3))
        )
      )
    end

    def create_firm_with_remote_advice(attributes)
      create_firm(
        attributes.merge(
          other_advice_methods: OtherAdviceMethod.where(id: rand(1..2))
        )
      )
    end

    def generate_advisers_and_offices
      firm1 = create_firm_with_in_person_advice(registered_name: 'Test Firm Central London')
      firm2 = create_firm_with_in_person_advice(registered_name: 'Test Firm East London')
      firm3 = create_firm_with_in_person_advice(registered_name: 'Test Firm Brighton')

      firm4 = create_firm_with_remote_advice(registered_name: 'Test Firm Remote 1')
      firm5 = create_firm_with_remote_advice(registered_name: 'Test Firm Remote 2')
      firm6 = create_firm_with_remote_advice(registered_name: 'Test Firm Remote 3')

      adviser1 = create_adviser_for_firm(firm: firm1, postcode: 'EC4V 4AY')
      adviser2 = create_adviser_for_firm(firm: firm1, postcode: 'EC1N 2TD')
      adviser3 = create_adviser_for_firm(firm: firm2, postcode: 'E1 0AE')
      adviser4 = create_adviser_for_firm(firm: firm2, postcode: 'E1 0AE')
      adviser5 = create_adviser_for_firm(firm: firm3, postcode: 'BN1 1AA')

      adviser6 = create_adviser_for_firm(firm: firm4, postcode: 'EC1N 2TD')
      adviser7 = create_adviser_for_firm(firm: firm5, postcode: 'EC1N 2TD')
      adviser8 = create_adviser_for_firm(firm: firm6, postcode: 'EC1N 2TD')

      in_person_advisers = [adviser1, adviser2, adviser3, adviser4, adviser5]
      remote_advisers = [adviser6, adviser7, adviser8]

      all_advisers = (in_person_advisers + remote_advisers)

      office1 = create_office_for_firm(firm: firm1, postcode: 'EC4V 4AY')
      office2 = create_office_for_firm(firm: firm1, postcode: 'EC1N 2TD')
      office3 = create_office_for_firm(firm: firm2, postcode: 'E1 0AE')

      all_offices = [office1, office2, office3]

      all_advisers.each(&:reload)

      @advisers = all_advisers.map do |adviser|
        AdviserSerializer.new(adviser).as_json
      end

      @offices = all_offices.map do |office|
        OfficeSerializer.new(office).as_json
      end
    end
  end
end
