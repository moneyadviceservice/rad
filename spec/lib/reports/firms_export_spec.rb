RSpec.describe Reports::FirmsExport do
  let(:firm) { create(:firm_with_principal) }
  let(:expected_row) { [firm.fca_number.to_s, "#{firm.principal.first_name} #{firm.principal.last_name}", firm.principal.email_address, firm.status] }

  it 'generates a csv file' do
    response = CSV.parse(described_class.new([firm]).generate_csv)

    expect(response).to eq(
      [
        Reports::FirmsExport::HEADER_ROW,
        expected_row
      ]
    )
  end
end
