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
  end
end
