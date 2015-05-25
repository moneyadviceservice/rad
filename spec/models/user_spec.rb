RSpec.describe User do
  describe 'validation' do
    it 'passes with valid email address' do
      subject.email = 'bill@example.com'
      subject.valid?
      expect(subject.errors_on(:email)).to be_empty
    end

    it 'fails with an invalid email address' do
      subject.email = 'bill'
      subject.valid?
      expect(subject.errors_on(:email)).not_to be_empty
    end


  end
end
