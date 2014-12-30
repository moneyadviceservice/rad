RSpec.describe Import::Mappers::SubsidiaryMapper, '#call' do
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

  let(:model_class) { double(create!: true) }

  subject { described_class.new(model_class) }

  it 'maps the attributes for `create!`' do
    subject.call(row)

    expect(model_class).to have_received(:create!)
    .with(
      fca_number: '100013',
      name: 'Medical Insurance Agency (MIA)'
    )
  end
end
