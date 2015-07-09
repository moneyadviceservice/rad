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
  end
end
