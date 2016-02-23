RSpec.describe SelfService::StatusPresenter do
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

  def firm_link_regex(model, text)
    /^<a.*href=.*#{model}.*#{firm.id}.*edit.*>#{text}<\/a>/
  end

  describe '#firm_details_link' do
    before { allow(firm).to receive(:trading_name?).and_return(is_trading_name) }

    context 'when the firm is a trading name' do
      let(:is_trading_name) { true }

      it 'provides a link to the trading name edit page' do
        expect(presenter.firm_details_link).to match(firm_link_regex('trading_names', 'Edit'))
      end
    end

    context 'when the firm is not a trading name' do
      let(:is_trading_name) { false }

      it 'provides a link to the parent firm edit page' do
        expect(presenter.firm_details_link).to match(firm_link_regex('firms', 'Edit'))
      end
    end
  end

  describe '#advisers_icon' do
    before { allow(firm).to receive(:advisers).and_return(advisers) }

    context 'when the firm has advisers' do
      let(:advisers) { ['an adviser'] }

      before { allow(firm).to receive(:primary_advice_method).and_return(primary_advice_method) }

      context 'and is local' do
        let(:primary_advice_method) { :local }

        it 'provides "tick"' do
          expect(presenter.advisers_icon).to eq('tick')
        end
      end

      context 'and is remote' do
        let(:primary_advice_method) { :remote }

        it 'provides "tick"' do
          expect(presenter.advisers_icon).to eq('tick')
        end
      end

      context 'and is nil' do
        let(:primary_advice_method) { nil }

        it 'provides "tick"' do
          expect(presenter.advisers_icon).to eq('tick')
        end
      end
    end

    context 'when the firm has no advisers' do
      let(:advisers) { [] }

      before { allow(firm).to receive(:primary_advice_method).and_return(primary_advice_method) }

      context 'and is local' do
        let(:primary_advice_method) { :local }

        it 'provides "exclamation"' do
          expect(presenter.advisers_icon).to eq('exclamation')
        end
      end

      context 'and is remote' do
        let(:primary_advice_method) { :remote }

        it 'provides "tick"' do
          expect(presenter.advisers_icon).to eq('tick')
        end
      end

      context 'and is nil' do
        let(:primary_advice_method) { nil }

        it 'provides "exclamation"' do
          expect(presenter.advisers_icon).to eq('exclamation')
        end
      end
    end
  end

  def adviser_link_regex(model, text)
    action = model == 'adviser' ? '.*new' : ''
    /^<a.*href=.*#{firm.id}.*#{model}#{action}.*>#{text}<\/a>/
  end

  describe '#advisers_link' do
    before { allow(firm).to receive(:advisers).and_return(advisers) }

    context 'when the firm has advisers' do
      let(:advisers) { ['an adviser'] }

      it 'provides a link to the manage advisers page' do
        expect(presenter.advisers_link).to match(adviser_link_regex('advisers', 'Manage'))
      end
    end

    context 'when the firm has no advisers' do
      let(:advisers) { [] }

      it 'provides a link to the new adviser page' do
        expect(presenter.advisers_link).to match(adviser_link_regex('adviser', 'Add'))
      end
    end
  end

  describe '#offices_icon' do
    before { allow(firm).to receive(:offices).and_return(offices) }

    context 'when the firm has offices' do
      let(:offices) { ['an office'] }

      it 'provides "tick"' do
        expect(presenter.offices_icon).to eq('tick')
      end
    end

    context 'when the firm has no offices' do
      let(:offices) { [] }

      it 'provides "exclamation"' do
        expect(presenter.offices_icon).to eq('exclamation')
      end
    end
  end

  def office_link_regex(model, text)
    action = model == 'office' ? '.*new' : ''
    /^<a.*href=.*#{firm.id}.*#{model}#{action}.*>#{text}<\/a>/
  end

  describe '#offices_link' do
    before { allow(firm).to receive(:offices).and_return(offices) }

    context 'when the firm has offices' do
      let(:offices) { ['an office'] }

      it 'provides a link to the manage offices page' do
        expect(presenter.offices_link).to match(office_link_regex('offices', 'Manage'))
      end
    end

    context 'when the firm has no offices' do
      let(:offices) { [] }

      it 'provides a link to the new office page' do
        expect(presenter.offices_link).to match(office_link_regex('office', 'Add'))
      end
    end
  end

  describe '#advisers_count' do
    it 'shows the number of advisers for the given firm' do
      allow(firm).to receive(:advisers).and_return(%w(adviser_1 adviser_2))
      expect(presenter.advisers_count).to eq(2)
    end
  end

  describe '#offices_count' do
    it 'shows the number of offices for the given firm' do
      allow(firm).to receive(:offices).and_return(%w(office_1 office_2 office_3))
      expect(presenter.offices_count).to eq(3)
    end
  end
end
