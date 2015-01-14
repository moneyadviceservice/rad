RSpec.describe Import::Mappers::AdviserMapper do
  it_behaves_like 'a mapper' do
    let(:row) do
      [
        'AAA00001',
        'Mr Benjamin Lovell',
        nil,
        nil,
        1,
        'BENJAMINLOVELL',
        '19800202'
      ]
    end

    let(:mapped_attributes) do
      {
        reference_number: 'AAA00001',
        name: 'Mr Benjamin Lovell'
      }
    end
  end
end
