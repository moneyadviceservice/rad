RSpec.feature 'Deleting an adviser from the admin interface', :inline_job_queue do
  include_context 'algolia index fake'

  let(:admin_adviser_page) { AdminAdviserPage.new }

  scenario 'Deleting an adviser' do
    given_there_are_advisers_for_a_firm
    and_the_advisers_are_present_in_the_directory
    when_i_visit_an_adviser_page
    and_i_click_delete_adviser
    then_the_adviser_is_deleted
    and_the_adviser_gets_removed_from_the_directory
    and_i_am_redirected_to_the_adviser_list_page
  end

  def given_there_are_advisers_for_a_firm
    @adviser_first = create(:advisers_retirement_firm)
    @firm = @adviser_first.firm
    @adviser_second = create(:advisers_retirement_firm, firm: @firm)
  end

  def and_the_advisers_are_present_in_the_directory
    directory_advisers = firm_advisers_in_directory(@firm)
    expect(directory_advisers.size).to eq 2
    expect(firm_total_advisers_in_directory(@firm)).to eq 2
    expect(directory_advisers.map { |adviser| adviser['objectID'] })
      .to eq [@adviser_first.id, @adviser_second.id]
  end

  def when_i_visit_an_adviser_page
    visit(admin_adviser_path(@adviser_first))
  end

  def and_i_click_delete_adviser
    admin_adviser_page.delete_adviser.click
  end

  def then_the_adviser_is_deleted
    expect(Adviser.find_by(id: @adviser_first.id)).to be_nil
  end

  def and_the_adviser_gets_removed_from_the_directory
    directory_advisers = firm_advisers_in_directory(@firm)
    expect(directory_advisers.size).to eq 1
    expect(firm_total_advisers_in_directory(@firm)).to eq 1
    expect(directory_advisers.map { |adviser| adviser['objectID'] })
      .to eq [@adviser_second.id]
  end

  def and_i_am_redirected_to_the_adviser_list_page
    expect(page.current_path).to eq admin_advisers_path
  end
end
