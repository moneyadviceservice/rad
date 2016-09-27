RSpec.describe River::Context do
  let(:stream)  { StringIO.new }
  let(:context) { River::Context.new }

  before { context.writer = stream }

  it '.writer= is defined' do
    expect(context).to respond_to(:writer=)
  end

  it '.write is defined' do
    expect(context).to respond_to(:write)
  end

  it 'is a subclass of Hash' do
    expect(River::Context.ancestors).to include(Hash)
  end

  context 'writer usage' do
    before { context.write('test') }

    it 'can write to file' do
      expect(stream.string).to eq 'test'
    end
  end
end
