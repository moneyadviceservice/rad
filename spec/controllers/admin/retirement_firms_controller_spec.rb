RSpec.describe Admin::RetirementFirmsController, type: :request do
  before { Timecop.freeze(Time.zone.parse('2016-05-04 00:00:00')) }
  after { Timecop.return }

  describe 'GET index' do
    context 'csv format' do
      before do
        create(:firm_with_principal)
        get admin_retirement_firms_path, params: { format: :csv }
      end

      it 'returns a csv file' do
        expect(response.header['Content-Type']).to eq('text/csv')
      end

      it 'has a timestamp in the filename' do
        expect(response.header['Content-Disposition']).to start_with('attachment; filename="retirement_firms_20160504000000.csv"')
      end
    end
  end

  describe 'GET adviser_report' do
    before do
      allow(Reports::PrincipalAdvisers).to receive(:data)
      get adviser_report_admin_retirement_firms_path, params: { format: :csv }
    end

    it 'gets data from the PrincipalAdvisers report' do
      expect(Reports::PrincipalAdvisers).to have_received(:data)
    end

    it 'provides it as a CSV' do
      expect(response.header['Content-Type']).to eq('text/csv')
    end

    it 'has a timestamped filename' do
      expect(response.header['Content-Disposition']).to start_with('attachment; filename="firms-advisers-20160504000000.csv"')
    end
  end
end
