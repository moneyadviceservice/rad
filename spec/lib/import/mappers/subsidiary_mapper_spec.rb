RSpec.describe Import::Mappers::SubsidiaryMapper do
  it_behaves_like 'a mapper' do
    let(:row) do
      [
        '100013',
        'Medical Insurance Agency (MIA)',
        '2',
        '20140210',
        nil,
        'MEDICALINSURANCEAGENCYMIA',
        '20140210'
      ]
    end

    let(:mapped_attributes) do
      {
        fca_number: '100013',
        name: 'Medical Insurance Agency (MIA)'
      }
    end
  end
end
