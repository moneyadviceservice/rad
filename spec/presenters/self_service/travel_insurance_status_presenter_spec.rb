RSpec.describe SelfService::TravelInsuranceStatusPresenter do

  let(:principal) { FactoryBot.create(:principal) }

  subject(:presenter) { described_class.new(firm) }

  context 'when the travel_insurance_firm is not publishable' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: false, principal: principal) }

    describe '#overall_status' do
      it 'provides "pending" if the firm is publishable but not approved' do
        expect(presenter.overall_status).to eq('unpublished')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "exclamation"' do
        expect(presenter.overall_status_icon).to eq('exclamation')
      end
    end
  end

  context 'when the travel_insurance_firm is publishable' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true, approved_at: nil) }

    describe '#overall_status' do
      it 'provides "pending" if the firm is publishable but not approved' do
        expect(presenter.overall_status).to eq('pending')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "exclamation"' do
        expect(presenter.overall_status_icon).to eq('tick')
      end
    end
  end

  context 'when the travel_insurance_firm is publishable' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true, approved_at: Time.zone.now) }
    describe '#overall_status' do
      it 'provides "published" ' do
        expect(presenter.overall_status).to eq('published')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "tick"' do
        expect(presenter.overall_status_icon).to eq('tick')
      end
    end
  end

  context 'when the travel_insurance_firm is hidden' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm_hidden, completed_firm: true,
      approved_at: Time.zone.now, hidden_at: Time.zone.now) }

    describe '#overall_status' do
      it 'provides "hidden" if the travel_insurance_firm is hidden' do
        expect(presenter.overall_status).to eq('hidden')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "tick"' do
        expect(presenter.overall_status_icon).to eq('tick')
      end
    end
  end
end
