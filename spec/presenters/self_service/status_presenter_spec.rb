RSpec.describe SelfService::StatusPresenter do
  def link_regex_for(route, text)
    /^<a.*href=.*#{route}.*#{firm.id}.*edit.*>#{text}<\/a>/
  end

  let(:firm) { FactoryGirl.create(:firm) }

  subject(:presenter) { described_class.new(firm) }

  context 'when the firm is publishable' do
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

  context 'when the firm is not publishable' do
    let(:firm) { FactoryGirl.create(:firm_without_offices) }

    describe '#overall_status' do
      it 'provides "published" if the firm is publishable' do
        expect(presenter.overall_status).to eq('unpublished')
      end
    end

    describe '#overall_status_icon' do
      it 'provides "exclamation"' do
        expect(presenter.overall_status_icon).to eq('exclamation')
      end
    end
  end

  describe '#firm_details_icon' do
    before { allow(firm).to receive(:registered?).and_return(firm_registered) }

    context 'when the firm is registered' do
      let(:firm_registered) { true }

      it 'provides "tick"' do
        expect(presenter.firm_details_icon).to eq('tick')
      end
    end

    context 'when the firm is not registered' do
      let(:firm_registered) { false }

      it 'provides "exclamation"' do
        expect(presenter.firm_details_icon).to eq('exclamation')
      end
    end
  end

  describe '#firm_details_link' do
    before { allow(firm).to receive(:trading_name?).and_return(is_trading_name) }

    context 'when the firm is a trading name' do
      let(:is_trading_name) { true }

      it 'provides a link to the trading name edit page' do
        expect(presenter.firm_details_link).to match(link_regex_for('trading_names', 'Edit'))
      end
    end

    context 'when the firm is not a trading name' do
      let(:is_trading_name) { false }

      it 'provides a link to the parent firm edit page' do
        expect(presenter.firm_details_link).to match(link_regex_for('firms', 'Edit'))
      end
    end
  end
end
