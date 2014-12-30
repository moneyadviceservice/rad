RSpec.shared_examples 'a mapper' do
  let(:model_class) { double(create!: true) }

  subject { described_class.new(model_class) }

  it 'maps the attributes for `create!`' do
    subject.call(row)

    expect(model_class).to have_received(:create!).with(mapped_attributes)
  end
end
