RSpec.describe ApplicationHelper, type: :helper do
  describe '#display_adviser_sign_in?' do
    it 'is true when the user is not signed in' do
      sign_out
      expect(helper.display_adviser_sign_in?).to eq(true)
    end

    it 'is false when the user is signed in' do
      sign_in User.new
      expect(helper.display_adviser_sign_in?).to eq(false)
    end
  end

  describe '#display_adviser_sign_out?' do
    it 'is false the user is not signed in' do
      sign_out
      expect(helper.display_adviser_sign_out?).to eq(false)
    end

    it 'is true when the user is signed in' do
      sign_in User.new
      expect(helper.display_adviser_sign_out?).to eq(true)
    end
  end
end
