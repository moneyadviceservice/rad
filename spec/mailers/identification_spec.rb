RSpec.describe Identification, '#contact' do
  let(:principal) { Principal.create!(email_address: 'ben@example.com') }

  subject { described_class.contact(principal) }

  it 'has a subject' do
    expect(subject.subject).to be_present
  end

  it 'has a from address' do
    expect(subject.from).to be_present
  end

  it 'addressed to the principal' do
    expect(subject.to).to contain_exactly(principal.email_address)
  end

  describe 'body' do
    it 'contains the tokenized URL' do
      expect(subject.body.decoded).to include(principal.token)
    end
  end
end
