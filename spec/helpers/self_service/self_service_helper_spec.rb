module SelfService
  RSpec.describe SelfServiceHelper, type: :helper do
    describe '#add_or_edit_self_service_trading_names_path' do
      subject { helper.create_or_update_self_service_trading_names_path(trading_name) }

      context 'the trading name is an existing record' do
        let(:trading_name) { FactoryBot.create(:trading_name) }

        it 'returns the create path' do
          expect(subject).to eq self_service_trading_name_path(trading_name)
        end
      end

      context 'the trading name is an existing record' do
        let(:trading_name) { FactoryBot.build(:trading_name) }

        it 'returns the create path' do
          expect(subject).to eq self_service_trading_names_path
        end
      end
    end

    describe '#office_address_table_cell' do
      let(:office) do
        FactoryBot.build(:office,
                          address_line_one: 'a',
                          address_line_two: 'b',
                          address_town: 'c',
                          address_county: 'd',
                          address_postcode: '!!!')
      end
      subject { helper.office_address_table_cell(office) }

      it 'returns the office address, not including postcode, as a comma separated string' do
        expect(subject).to eq('a, b, c, d')
      end

      it 'filters out blank fields' do
        office.address_line_two = ''
        office.address_town = nil
        expect(subject).to eq('a, d')
      end
    end

    describe '#first_onboarded_firm_for' do
      let(:principal) { create(:principal, fca_number: '123456') }

      def make_firm_look_registered(firm)
        firm.__set_registered(true)
        firm.save(validate: false)
      end

      context 'when the principal has no registered firms' do
        it 'is nil' do
          expect(helper.first_onboarded_firm_for(principal)).to be_nil
        end
      end

      context 'when the principal has registered firm and has no trading names' do
        it 'provides the firm' do
          make_firm_look_registered(principal.firm)
          expect(helper.first_onboarded_firm_for(principal)).to eq(principal.firm)
        end
      end

      context 'principal has not registered firm but has a registered trading name' do
        it 'returns the trading name' do
          trading_name = create(:trading_name, fca_number: principal.fca_number)

          expect(helper.first_onboarded_firm_for(principal)).to eq(trading_name)
        end
      end

      context 'principal has registered firm and registered trading name' do
        it 'returns the firm' do
          make_firm_look_registered(principal.firm)
          create(:trading_name, fca_number: principal.fca_number)

          expect(helper.first_onboarded_firm_for(principal)).to eq(principal.firm)
        end
      end
    end

    describe '#status_icon' do
      it 'returns an svg tag' do
        expect(helper.status_icon('tick')).to match(/<svg /)
      end

      it 'adds a class for the icon type' do
        expect(helper.status_icon('tick')).to include('status__icon--tick')
      end

      it 'includes the image for the icon type' do
        expect(helper.status_icon('tick')).to include('#icon-tick')
      end
    end

    describe '#options_for_cover_ages' do
      it 'returns an array' do
        expect(helper.options_for_cover_ages).to be_a_kind_of(Array)
      end

      it 'includes no_age_restriction and not_offered options' do
        expect(helper.options_for_cover_ages).to include(['No age restriction', 1000])
        expect(helper.options_for_cover_ages).to include(['Not offered', -1])
      end

      it 'includes numbers 65 to 100 in options style array' do
        ages_array = (65..100).to_a.map { |k| [k, k] }
        expect(helper.options_for_cover_ages).to include(*ages_array)
      end
    end

    describe '#options_for_how_much_in_advance' do
      it 'returns an array' do
        expect(helper.options_for_how_much_in_advance).to be_a_kind_of(Array)
      end

      it 'includes the correct key values of dropdown' do
        items = t('self_service.travel_insurance_firms_edit.service_details.advance_of_trip_cover_select')
        select_data = items.map { |k, v| [v[:label], k] }
        expect(helper.options_for_how_much_in_advance).to eq(select_data)
      end
    end
  end
end
