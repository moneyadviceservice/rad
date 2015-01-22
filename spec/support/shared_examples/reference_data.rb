RSpec.shared_examples 'reference data' do
  let(:factory) { described_class.model_name.singular.to_sym }

  it 'is valid with valid attributes' do
    expect(build(factory)).to be_valid
  end
end
