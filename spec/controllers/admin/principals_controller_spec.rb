RSpec.describe Admin::PrincipalsController, type: :request do
  before { sign_in(user) }

  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:principal) { FactoryBot.create(:principal) }

  describe 'DELETE #destroy' do
    context 'when successful' do
      it 'removes the principal and the user', :aggregate_failures do
        expect { delete admin_principal_path(principal) }
          .to change(Principal, :count)
          .by(-1)
          .and change(User, :count)
          .by(-1)

        expect(flash[:notice]).to match(/Successfully deleted/)
      end
    end
  end
end
