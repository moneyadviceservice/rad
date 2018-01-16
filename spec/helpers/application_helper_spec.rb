RSpec.describe ApplicationHelper, type: :helper do
  describe '#render_breadcrumbs' do
    it 'renders the the shared/breadcrumbs template' do
      expect(helper).to receive(:render).with('shared/breadcrumbs', anything)
      helper.render_breadcrumbs []
    end

    it 'passes the crumb list in the `breadcrumbs` variable' do
      expect(helper).to receive(:render).with(anything, breadcrumbs: [])
      helper.render_breadcrumbs []
    end
  end

  describe '#register_path' do
    it 'provides the start of the registration flow' do
      expect(helper.register_path).to eq(prequalify_principals_path)
    end
  end

  describe '#paragraphs' do
    subject { helper.paragraphs(paragraphs, options) }
    let(:options) { {} }

    context 'when passed a list' do
      let(:paragraphs) { %w[hello world] }
      it { is_expected.to eq '<p>hello</p><p>world</p>' }

      context 'when passed html options' do
        let(:options) { { class: 'hello' } }
        it { is_expected.to eq '<p class="hello">hello</p><p class="hello">world</p>' }
      end
    end

    context 'when passed an empty array' do
      let(:paragraphs) { [] }
      it { is_expected.to eq '' }
    end

    context 'when passed a string' do
      let(:paragraphs) { 'hello' }
      it { is_expected.to eq '<p>hello</p>' }
    end
  end

  describe '#layout_class' do
    it 'provides l-content for a non-devise controller' do
      allow(controller).to receive(:devise_controller?).and_return(false)
      expect(helper.layout_class).to eq('l-content')
    end

    it 'provides l-registration for a devise controller' do
      allow(controller).to receive(:devise_controller?).and_return(true)
      expect(helper.layout_class).to eq('l-registration')
    end
  end
end
