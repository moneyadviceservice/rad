RSpec.describe 'Token Authentication', type: :request do
  let(:principal) { create(:principal) }

  describe 'GET /principals/:token/firm' do
    before do
      get principal_firm_path(principal)
    end

    context 'with an invalid token' do
      let(:principal) do
        create(:principal) do |p|
          p.token = 'abcdefg'
        end
      end

      it 'redirects to the error page' do
        expect(response).to redirect_to(error_path)
      end
    end
  end
end
