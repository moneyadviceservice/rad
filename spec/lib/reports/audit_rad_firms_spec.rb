RSpec.describe Reports::AuditRadFirms do
  include_context 'fca api ok response'

  describe '#to_csv' do
    let(:principal) do
      create(
        :principal,
        fca_number: 123_456,
        first_name: 'Bryan',
        last_name: 'Adams'
      )
    end
    let!(:firm) do
      create(
        :firm,
        registered_name: 'Financial LTDA',
        fca_number: 123_456,
        website_address: 'https://financialltda.co.uk',
        principal: principal,
        created_at: Time.new(2019, 1, 1).utc
      )
    end
    let(:csv_file) { Tempfile.new('temp_file.csv') }

    before do
      firm.main_office.update!(
        address_line_one: 'Suite 3b',
        address_line_two: 'Beancross Road',
        address_town: 'Grangemouth',
        address_county: 'Stirlingshire',
        address_postcode: 'FK3 8WH',
        email_address: 'irving_thiel@lind.biz',
        telephone_number: '07111 333 222'
      )
      firm.reload
    end

    it 'stores rad firms to csv file' do
      described_class.new(csv_file: csv_file).to_csv
      expect(CSV.read(csv_file).last).to eq(
        [
          'Bryan Adams',
          '123456',
          'Financial LTDA',
          'Suite 3b - Beancross Road - Grangemouth - Stirlingshire - FK3 8WH',
          'irving_thiel@lind.biz',
          '07111 333 222',
          'https://financialltda.co.uk',
          'January 01, 2019 00:00'
        ]
      )
    end
  end
end
