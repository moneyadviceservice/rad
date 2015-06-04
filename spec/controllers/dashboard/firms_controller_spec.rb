module Dashboard
  RSpec.describe Dashboard::FirmsController, type: :controller do
    let(:principal) { FactoryGirl.create(:principal) }
    let(:firm) do
      firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
      principal.firm.update_attributes(firm_attrs)
      principal.firm
    end
    let(:user) { FactoryGirl.create :user, principal: firm.principal }
    before { sign_in(user) }

    def extract_firm_params(firm, params = {})
      firm_params = firm.attributes
      firm_params.symbolize_keys!
      firm_params[:initial_advice_fee_structure_ids] = firm.initial_advice_fee_structure_ids
      firm_params[:ongoing_advice_fee_structure_ids] = firm.ongoing_advice_fee_structure_ids
      firm_params[:allowed_payment_method_ids] = firm.allowed_payment_method_ids
      firm_params[:investment_size_ids] = firm.investment_size_ids
      firm_params.merge(params)
    end

    describe 'GET #index' do
      context 'when all trading names are registered' do
        it 'assigns all trading names' do
          get :index
          expect(assigns(:trading_names).count).to eq 3
        end
      end

      context 'when some trading names are registered' do
        before do
          trading_name = firm.trading_names.first
          trading_name.email_address = nil
          trading_name.save(validate: false)
        end

        it 'assigns only registered trading names' do
          get :index
          expect(assigns(:trading_names).count).to eq 2
        end
      end
    end

    describe 'GET #edit' do
      let(:trading_name) { FactoryGirl.create(:firm, parent_id: firm.id) }
      before { get :edit, id: firm.id }

      it 'assigns the firm' do
        expect(assigns(:firm)).to eq firm
      end

      it 'renders the edit page' do
        expect(response).to render_template 'dashboard/firms/edit'
      end
    end

    describe 'PATCH #update' do
      let(:firm) { FactoryGirl.create(:firm) }

      context 'when passed valid details' do
        let(:firm_params) { extract_firm_params(firm, email_address: 'valid@example.com') }
        before { patch :update, id: firm.id, firm: firm_params }

        it 'updates the firm' do
          expect(firm.reload.email_address).to eq firm_params[:email_address]
        end

        it 'renders the edit page' do
          expect(response).to render_template 'dashboard/firms/edit'
        end
      end

      context 'when passed invalid details' do
        let(:firm_params) { extract_firm_params(firm, email_address: 'not_valid') }
        before { patch :update, id: firm.id, firm: firm_params }

        it 'does not update the firm' do
          expect(firm.reload.email_address).not_to eq firm_params[:email_address]
        end

        it 'renders the edit page' do
          expect(response).to render_template 'dashboard/firms/edit'
        end
      end
    end
  end
end
