module SelfService
  RSpec.describe SelfServiceHelper, type: :helper do
    describe '#add_or_edit_self_service_trading_names_path' do
      subject { helper.create_or_update_self_service_trading_names_path(trading_name) }

      context 'the trading name is an existing record' do
        let(:trading_name) { FactoryGirl.create(:trading_name) }

        it 'returns the create path' do
          expect(subject).to eq self_service_trading_name_path(trading_name)
        end
      end

      context 'the trading name is an existing record' do
        let(:trading_name) { FactoryGirl.build(:trading_name) }

        it 'returns the create path' do
          expect(subject).to eq self_service_trading_names_path
        end
      end
    end

    describe '#office_address_table_cell' do
      let(:office) do
        FactoryGirl.build(:office,
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

    describe '#first_registered_firm_for' do
      let(:principal) { create(:principal, fca_number: '123456') }

      def make_firm_look_registered(firm)
        firm.update_attribute(Firm::REGISTERED_MARKER_FIELD,
                              Firm::REGISTERED_MARKER_FIELD_VALID_VALUES.first)
      end

      context 'when the principal has no registered firms' do
        it 'is nil' do
          expect(helper.first_registered_firm_for(principal)).to be_nil
        end
      end

      context 'when the principal has registered firm and has no trading names' do
        it 'provides the firm' do
          make_firm_look_registered(principal.firm)
          expect(helper.first_registered_firm_for(principal)).to eq(principal.firm)
        end
      end

      context 'principal has not registered firm but has a registered trading name' do
        it 'returns the trading name' do
          trading_name = create(:trading_name, fca_number: principal.fca_number)

          expect(helper.first_registered_firm_for(principal)).to eq(trading_name)
        end
      end

      context 'principal has registered firm and registered trading name' do
        it 'returns the firm' do
          make_firm_look_registered(principal.firm)
          create(:trading_name, fca_number: principal.fca_number)

          expect(helper.first_registered_firm_for(principal)).to eq(principal.firm)
        end
      end
    end
  end
end
