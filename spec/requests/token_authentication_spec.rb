RSpec.describe 'Token Authentication', :type => :request do
  let(:principal) { FactoryGirl.create(:principal) }

  describe 'GET /firms' do
    before do
      get firms_path(token: token)
    end

    context 'with a valid token' do
      let(:token) { principal.token }

      it 'returns 200 response' do
        expect(response.status).to be(200)
      end
    end

    context 'with an invalid token' do
      let(:token) { 'invalid-token' }

      it 'returns 302 response' do
        expect(response.status).to be(302)
      end

      it 'redirects to the error page' do
        expect(response).to redirect_to(error_path)
      end
    end
  end
end
