#
# A routing test implemented as a feature. This is necessary so we can fake
# logins.
# See: https://github.com/plataformatec/devise/issues/1670#issuecomment-4060164
#

RSpec.describe 'GET /', type: :feature do
  context 'when not logged in' do
    it 'routes to the root_path' do
      visit '/'
      expect(current_path).to eq(root_path)
    end
  end

  context 'when logged in to the self_service area' do
    let(:user) { FactoryGirl.create(:user, principal: principal) }
    let(:principal) { FactoryGirl.create(:principal) }

    before { login_as(user, scope: :user) }

    it 'redirects to /self_service/firms' do
      visit '/'
      expect(current_path).to eq(self_service_firms_path)
    end
  end
end
