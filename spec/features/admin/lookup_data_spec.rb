RSpec.feature 'Viewing lookup data' do
  scenario 'Successfully viewing lookup data pages' do
    lookup_paths = [
      admin_lookup_firms_path,
      admin_lookup_advisers_path,
      admin_lookup_subsidiaries_path
    ]

    lookup_paths.each do |lookup_path|
      visit lookup_path
      expect(page.status_code).to eq(200)
    end
  end
end
