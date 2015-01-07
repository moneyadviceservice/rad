RSpec.describe 'Token Authentication', type: :request do
  let(:principal) { create(:principal) }

  describe 'GET /firms' do
    before do
      get principal_firm_path(principal)
    end

    context 'with a valid token' do
      it 'returns 200 response' do
        expect(response.status).to be(200)
      end
    end

    context 'with an invalid token' do
      let(:principal) do
        create(:principal) do |p|
          p.token = 'abcdefg'
        end
      end

      it 'returns 302 response' do
        expect(response.status).to be(302)
      end

      it 'redirects to the error page' do
        expect(response).to redirect_to(error_path)
      end
    end
  end
end
