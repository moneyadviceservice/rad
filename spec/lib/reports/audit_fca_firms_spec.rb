RSpec.describe Reports::AuditFcaFirms do
  describe '#to_csv' do
    let(:csv_file) { Tempfile.new('temp_file.csv') }
    let(:fca_file) { fixture('firms.ext') }

    it 'stores fca firms to csv file' do
      described_class.new(fca_file: fca_file, csv_file: csv_file).to_csv
      expect(CSV.read(csv_file, encoding: 'ISO-8859-1').last).to eq(
        [
          '131581',
          'S £ C Limited',
          '44 01277 231 505',
          '44 01277 230 572',
          '151 High Street - Limited - Test - 4SA'
        ]
      )
    end
  end
end
