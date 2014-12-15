RSpec.describe Import::Mappers::FirmMapper, '#call' do
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

  let(:model_class) { double(create!: true) }

  subject { described_class.new(model_class) }

  it 'maps the attributes for `create!`' do
    subject.call(row)

    expect(model_class).to have_received(:create!)
    .with(
      fca_number: '100013',
      registered_name: 'Skipton Financial Services Ltd'
    )
  end
end
