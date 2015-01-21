RSpec.describe Adviser do
  it 'is valid with valid attributes' do
    expect(build(:adviser)).to be_valid
  end
end
