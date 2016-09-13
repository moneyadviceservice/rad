RSpec.describe FcaImport, type: :model do
  before(:all) { FactoryGirl.create(:not_confirmed_import) }

  describe 'scopes' do
    it '.not_confirmed exists' do
      expect(FcaImport.not_confirmed).to eq FcaImport.where.not(confirmed: true)
    end
  end

  describe '.lookup_advisers' do
    xit 'returns diff array' do
    end
  end
end
