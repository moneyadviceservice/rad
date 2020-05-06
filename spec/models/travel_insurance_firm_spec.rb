RSpec.describe TravelInsuranceFirm, type: :model do
  subject(:firm) { build(:travel_insurance_firm) }

  context 'when the corresponding principal exists' do
    context 'and the firm is successfully saved' do
      describe 'cached question ansewers not set directly on the model' do
        it 'get saved along with the model' do
        end
        it 'get cleared from the internal cache' do
        end
      end
      describe 'cached question ansewers also set directly on the model' do
        it 'do not get updated from the cache' do
        end
        it 'get cleared from the internal cache' do
        end
      end
    end
    describe 'non-cached question answers' do
      describe 'not set directly on the model' do
        it 'do not get saved along with the model' do
        end
        it 'are not present in the cache' do
        end
      end
      describe 'set directly on the model' do
        it 'get saved unchanged along with the model' do
        end
        it 'do not exist in the cache' do
        end
      end
    end

    context 'and the firm is not successfully saved' do
      describe 'cached question ansewers not set directly on the model' do
        it 'do not get saved' do
        end
        it 'get cleared from the internal cache' do
        end
      end
      describe 'cached question ansewers also set directly on the model' do
        it 'do not get updated from the cache' do
        end
        it 'get cleared from the internal cache' do
        end
      end
    end
    describe 'non-cached question answers' do
      describe 'not set directly on the model' do
        it 'do not get saved' do
        end
        it 'are not present in the cache' do
        end
      end
      describe 'set directly on the model' do
        it 'do not get saved' do
        end
        it 'do not exist in the cache' do
        end
      end
    end
  end
end
