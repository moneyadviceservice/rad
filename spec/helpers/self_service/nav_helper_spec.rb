module SelfService
  RSpec.describe NavHelper, type: :helper do
    describe '#self_service_firm_details_url' do
      let(:firm) { FactoryGirl.create(:firm_with_trading_names) }

      context 'when passed a parent firm object' do
        let(:arg) { firm }

        it 'returns a link to the firm edit page' do
          expect(helper.self_service_firm_details_url(arg))
            .to eq(edit_self_service_firm_path(arg))
        end
      end

      context 'when passed a trading name firm object' do
        let(:arg) { firm.trading_names.first }

        it 'returns a link to the trading name edit page' do
          expect(helper.self_service_firm_details_url(arg))
            .to eq(edit_self_service_trading_name_path(arg))
        end
      end
    end
  end
end
