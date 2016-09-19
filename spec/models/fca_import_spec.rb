RSpec.describe FcaImport, type: :model do
  describe 'scope .not_confirmed' do
    context 'when import has finished' do
      before { FactoryGirl.create(:not_confirmed_import) }
      it 'returns current import obj model' do
        expect(FcaImport.not_confirmed.last.status).to eq('processed')
      end
    end

    context 'when import has not finished yet' do
      before { FactoryGirl.create(:import) }
      it 'returns current import obj model' do
        expect(FcaImport.not_confirmed.last.status).to eq('processing')
      end
    end
  end

  describe 'validation' do
    describe 'status' do
      subject { FactoryGirl.build(:import, status: status) }
      FcaImport::STATUSES.each do |s|
        let(:status) { s }
        it "is included in #{FcaImport::STATUSES}" do
          expect(subject).to be_valid
        end
      end
    end

    describe 'files' do
      let(:same_args) { FactoryGirl.attributes_for(:import) }
      before { FactoryGirl.create(:import) }
      it 'cannot create duplicate import based on files' do
        import = FcaImport.create(same_args)
        expect(import.errors[:files]).not_to be_empty
      end
    end
  end

  describe 'status methods' do
    let!(:import) { FactoryGirl.build(:import, status: status) }
    subject { import.send("#{status}?".to_sym) }

    context 'processing?' do
      let(:status) { 'processing' }
      it { is_expected.to be true }
    end

    context 'processed?' do
      let(:status) { 'processed' }
      it { is_expected.to be true }
    end

    context 'confirmed?' do
      let(:status) { 'confirmed' }
      it { is_expected.to be true }
    end

    context 'cancelled?' do
      let(:status) { 'cancelled' }
      it { is_expected.to be true }
    end
  end
end
