RSpec.describe River::Context do
  it '.writer= is defined' do
    expect(subject).to respond_to(:writer=)
  end

  it '.write is defined' do
    expect(subject).to respond_to(:write)
  end

  it 'is a subclass of Hash' do
    expect(River::Context.ancestors).to include(Hash)
  end

  context 'writer usage' do
    let(:file) { StringIO.new }

    before { subject.writer = file }

    it 'can write to file' do
      subject.write('test')
      expect(file.string).to eq 'test'
    end
  end
end
