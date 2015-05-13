RSpec.feature 'Deleting an adviser from the admin interface' do
  let(:admin_adviser_page) { AdminAdviserPage.new }

  scenario 'Deleting an adviser' do
    given_there_is_an_adviser
    when_i_visit_an_adviser_page
    and_i_click_delete_adviser
    then_the_adviser_is_deleted
    and_i_am_redirected_to_the_adviser_list_page
  end
end

def given_there_is_an_adviser
  @adviser = create(:adviser)
end

def when_i_visit_an_adviser_page
  visit(admin_adviser_path(@adviser))
end

def and_i_click_delete_adviser
  admin_adviser_page.delete_adviser.click
end

def then_the_adviser_is_deleted
  expect(Adviser.find_by_id(@adviser.id)).to be_nil
end

def and_i_am_redirected_to_the_adviser_list_page
  expect(page.current_path).to eq admin_advisers_path
end
