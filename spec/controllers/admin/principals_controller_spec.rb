RSpec.describe Admin::PrincipalsController, type: :request do
  before { sign_in(user) }

  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:principal) { FactoryBot.create(:principal) }

  describe 'DELETE #destroy' do
    subject { delete admin_retirement_principal_path(principal) }

    context 'when successful' do
      it 'removes the principal and the user', :aggregate_failures do
        expect { subject }
          .to change(Principal, :count)
          .by(-1)
          .and change(User, :count)
          .by(-1)

        expect(flash[:notice]).to match(/Successfully deleted/)
      end

      it 'redirects to the principals index' do
        expect(subject).to redirect_to(admin_retirement_principals_path)
      end
    end
  end
end
