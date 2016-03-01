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
    describe 'edit page link' do
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

    describe 'button label' do
      before { allow(firm).to receive(:registered?).and_return(firm_registered) }

      context 'when the firm is registered' do
        let(:firm_registered) { true }

        it 'sets the button text to edit' do
          expect(presenter.firm_details_link).to match('Edit')
        end
      end

      context 'when the firm is not registered' do
        let(:firm_registered) { false }

        it 'sets the button text to add' do
          expect(presenter.firm_details_link).to match('Add')
        end
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

      it 'provides a link to the advisers index page' do
        expect(presenter.advisers_link).to match(adviser_link_regex('advisers', 'Edit'))
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

      it 'provides a link to the offices index page' do
        expect(presenter.offices_link).to match(office_link_regex('offices', 'Edit'))
      end
    end

    context 'when the firm has no offices' do
      let(:offices) { [] }

      it 'provides a link to the new office page' do
        expect(presenter.offices_link).to match(office_link_regex('office', 'Add'))
      end
    end
  end

  describe '#needs_advisers?' do
    before { allow(firm).to receive(:advisers).and_return(advisers) }

    context 'when the firm has advisers' do
      let(:advisers) { ['an adviser'] }

      before { allow(firm).to receive(:primary_advice_method).and_return(primary_advice_method) }

      context 'and is local' do
        let(:primary_advice_method) { :local }

        it 'is false' do
          expect(presenter.needs_advisers?).to eq(false)
        end
      end

      context 'and is remote' do
        let(:primary_advice_method) { :remote }

        it 'is false' do
          expect(presenter.needs_advisers?).to eq(false)
        end
      end

      context 'and is nil' do
        let(:primary_advice_method) { nil }

        it 'is false' do
          expect(presenter.needs_advisers?).to eq(false)
        end
      end
    end

    context 'when the firm has no advisers' do
      let(:advisers) { [] }

      before { allow(firm).to receive(:primary_advice_method).and_return(primary_advice_method) }

      context 'and is local' do
        let(:primary_advice_method) { :local }

        it 'is true' do
          expect(presenter.needs_advisers?).to eq(true)
        end
      end

      context 'and is remote' do
        let(:primary_advice_method) { :remote }

        it 'is false' do
          expect(presenter.needs_advisers?).to eq(false)
        end
      end

      context 'and is nil' do
        let(:primary_advice_method) { nil }

        it 'provides "exclamation"' do
          expect(presenter.needs_advisers?).to eq(true)
        end
      end
    end
  end

  describe '#needs_offices?' do
    before { allow(firm).to receive(:offices).and_return(offices) }

    context 'when the firm has offices' do
      let(:offices) { ['an office'] }

      it 'is false' do
        expect(presenter.needs_offices?).to eq(false)
      end
    end

    context 'when the firm has no offices' do
      let(:offices) { [] }

      it 'is true' do
        expect(presenter.needs_offices?).to eq(true)
      end
    end
  end
end
