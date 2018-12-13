module SelfService
  RSpec.describe NavHelper, type: :helper do
    let(:firm) { FactoryGirl.create(:firm_with_trading_names) }

    describe '#self_service_firm_details_url' do
      context 'when passed a parent firm object' do
        let(:arg) { firm }

        it 'returns a link to the firm edit page' do
          expect(helper.self_service_firm_details_url(arg))
            .to eq(edit_self_service_firm_path(arg))
        end
      end

      context 'when passed a trading name firm object' do
        let(:arg) { firm.trading_names.first }

        it 'returns a link to the trading name edit page' do
          expect(helper.self_service_firm_details_url(arg))
            .to eq(edit_self_service_trading_name_path(arg))
        end
      end
    end

    describe '#tab_link' do
      let(:content) { 'Hello MAS' }
      let(:url_path) { 'fake_url_path' }
      let(:extra_css_classes) { 'extra_css_class1 extra_css_class2' }

      subject { helper.tab_link(url_path, extra_css_classes, &-> { content }) }

      it 'creates a link for the given url_path' do
        expect(subject).to match(/href="#{url_path}"/)
      end

      it 'includes the css_classes' do
        expect(subject).to match(/#{extra_css_classes}/)
      end

      context 'active tab marking' do
        let(:test_path) { edit_self_service_trading_name_path(firm) }

        before do
          allow_any_instance_of(ActiveLinkTo)
            .to receive(:is_active_link?).and_return(is_active_link)
        end

        context 'when the link passed is the currently requested url' do
          let(:is_active_link) { true }

          it 'returns "is-active"' do
            expect(subject).to match(/is-active/)
          end
        end

        context 'when the link passed is not the currently requested url' do
          let(:is_active_link) { false }

          it 'returns "is-inactive"' do
            expect(subject).to match(/is-inactive/)
          end
        end
      end

      it 'gets the link content from the given block' do
        expect(subject).to match(%r{>#{content}</a>})
      end
    end
  end
end
