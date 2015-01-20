RSpec.describe Firm do
  it 'is valid with valid attributes' do
    expect(build(:firm)).to be_valid
  end
end
