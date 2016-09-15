RSpec.describe FcaImport, type: :model do
  before(:all) { FactoryGirl.create(:not_confirmed_import) }

  describe 'scopes' do
    it '.not_confirmed exists' do
      expect(FcaImport.not_confirmed.last.id).to eq FcaImport.where.not(confirmed: true).last.id
    end
  end
end
