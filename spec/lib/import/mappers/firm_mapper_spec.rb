RSpec.describe Import::Mappers::FirmMapper do
  it_behaves_like 'a mapper' do
    let(:row) do
      [
        '100013',
        'Skipton Financial Services Ltd',
        '5',
        '1',
        'N',
        'Skipton Financial Services Ltd',
        'The Bailey',
        nil,
        nil,
        'Skipton',
        'N Yorkshire',
        'BD23',
        '1XT',
        '44',
        '01756',
        '694 007',
        '44',
        '01756',
        '694 601',
        'Authorised',
        '20011201',
        '20011201',
        'SKIPTONFINANCIALSERVICESLTD',
        '20141023',
        nil
      ]
    end

    let(:mapped_attributes) do
      {
        fca_number: '100013',
        registered_name: 'Skipton Financial Services Ltd'
      }
    end
  end
end
