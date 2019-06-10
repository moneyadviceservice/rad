RSpec.describe Admin::PrincipalsController, type: :controller do
  include_context 'fca api ok response'

  before { sign_in(user) }

  let(:user) { FactoryGirl.create(:user, principal: principal) }
  let(:principal) { FactoryGirl.create(:principal) }

  describe 'DELETE #destroy' do
    context 'when successful' do
      it 'removes the principal and the user', :aggregate_failures do
        expect { delete :destroy, id: principal.id }
          .to change(Principal, :count).by(-1).and change(User, :count).by(-1)

        expect(flash[:notice]).to match(/Successfully deleted/)
      end
    end

    context 'when an exception is raised' do
      before do
        Principal.set_callback(:destroy, :around, -> { raise StandardError })
      end

      after do
        Principal.reset_callbacks(:destroy)
      end

      def silence
        yield
      rescue StandardError
        nil
      end

      it 'does not remove neither the principal nor the user' do
        aggregate_failures do
          expect { silence { delete :destroy, id: principal.id } }
            .to change(Principal, :count).by(0).and change(User, :count).by(0)

          expect(flash[:notice]).not_to match(/Successfully deleted/)
        end
      end
    end
  end
end
