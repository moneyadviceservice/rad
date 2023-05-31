RSpec.describe 'Legacy redirects', type: :request do
  context 'when requested from the legacy radsignup.moneyadviceservice.org.uk host' do
    it 'redirects tools to the correct landing page' do
      host! 'radsignup.moneyadviceservice.org.uk'

      get '/retirement_advice_registrations/prequalify?123'
      expect(request).to redirect_to('https://radsignup.moneyhelper.org.uk/retirement_advice_registrations/prequalify?123')
    end
  end
end
