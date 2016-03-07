RSpec.describe Admin::Reports::MetricsController, type: :controller do
  describe '#download' do
    let(:snapshot) { Snapshot.create(firms_with_no_minimum_fee: 123) }
    let(:snapshot_filename) do
      date = snapshot.created_at
      "snapshot-#{date.year}-#{date.month}-#{date.day}.csv"
    end
    let(:csv) { CSV.new(response.body, headers: :first_row) }

    before do
      get :download, id: snapshot
    end

    it 'has the correct filename' do
      expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"#{snapshot_filename}\"")
    end

    it 'has the correct headers' do
      csv.read
      expect(csv.headers).to eq(%w(metric value))
    end

    it 'contains snapshot attributes' do
      row = csv.shift
      expect(row['metric']).to eq('Firms with no minimum fee')
      expect(row['value']).to eq('123')
    end
  end
end
