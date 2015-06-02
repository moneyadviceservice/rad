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
end
