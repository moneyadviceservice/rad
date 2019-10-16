RSpec.describe Admin::FirmsController, type: :request do
  describe 'GET adviser_report' do
    before :each do
      allow(Reports::PrincipalAdvisers).to receive(:data)

      Timecop.freeze(Time.zone.parse('2016-05-04 00:00:00'))

      get :adviser_report, format: :csv
    end

    after :each do
      Timecop.return
    end

    it 'gets data from the PrincipalAdvisers report' do
      expect(Reports::PrincipalAdvisers).to have_received(:data)
    end

    it 'provides it as a CSV' do
      expect(response.header['Content-Type']).to eq('text/csv')
    end

    it 'has a timestamped filename' do
      expect(response.header['Content-Disposition']).to eq('attachment; filename="firms-advisers-20160504000000.csv"')
    end
  end

  it 'responds succesfully' do
    get :adviser_report, format: :csv
    expect(response).to be_success
  end
end
