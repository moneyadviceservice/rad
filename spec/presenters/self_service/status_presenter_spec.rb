RSpec.describe SelfService::StatusPresenter do
  subject(:presenter) { described_class.new(firm) }

  context 'when the firm is publishable' do
    let(:firm) { FactoryGirl.create(:firm) }

    describe '#overall_status' do
      it 'provides "published" ' do
        expect(presenter.overall_status).to eq('published')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "tick" ' do
        expect(presenter.overall_status_icon).to eq('tick')
      end
    end
  end

  context 'when the firm is not publishable' do
    let(:firm) { FactoryGirl.create(:firm_without_offices) }

    describe '#overall_status' do
      it 'provides "published" if the firm is publishable' do
        expect(presenter.overall_status).to eq('unpublished')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "exclamation" ' do
        expect(presenter.overall_status_icon).to eq('exclamation')
      end
    end
  end
end
