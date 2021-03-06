RSpec.feature 'Move advisers between firms', :inline_job_queue do
  include_context 'algolia index fake'

  let(:adviser) { create(:adviser) }
  let(:from_firm) { create(:firm_with_principal, advisers: [adviser]) }
  let(:destination_firm) { create(:firm) }
  let(:firm_page) { Admin::FirmPage.new }
  let(:move_advisers_page) { Admin::MoveAdvisers::MoveAdvisersPage.new }
  let(:choose_firm_page) { Admin::MoveAdvisers::ChooseFirmPage.new }
  let(:choose_subsidiary_page) { Admin::MoveAdvisers::ChooseSubsidiaryPage.new }
  let(:confirm_page) { Admin::MoveAdvisers::ConfirmPage.new }
  let(:move_page) { Admin::MoveAdvisers::MovePage.new }

  before do
    create :user, principal: from_firm.principal
  end

  scenario 'Moving an adviser from one firm to another' do
    given_i_want_to_move_an_adviser_from_firm(from_firm)
    and_i_want_to_move_adviser(adviser)
    and_i_want_to_move_to_firm(destination_firm)
    and_adviser_is_associated_to_firm_in_the_directory(adviser, from_firm)
    when_i_confirm_my_selection
    then_the_adviser_is_moved
    and_adviser_is_associated_to_firm_in_the_directory(adviser, destination_firm)
  end

  scenario 'When no advisers are selected to move' do
    given_i_do_not_specify_any_advisers_to_move
    then_i_am_told_about_the_problem_on(choose_firm_page)
  end

  scenario 'When the to-firm does not exist' do
    given_i_supply_a_non_existent_fca_number
    then_i_am_told_about_the_problem_on(choose_subsidiary_page)
  end

  scenario 'When a subsidiary has not been selected' do
    given_i_forget_to_select_a_subsidiary
    then_i_am_told_about_the_problem_on(confirm_page)
  end

  def given_i_want_to_move_an_adviser_from_firm(firm)
    firm_page.load(firm_id: firm.id)
    expect(firm_page).to be_displayed
    firm_page.move_advisers.click
  end

  def and_i_want_to_move_adviser(adviser)
    expect(move_advisers_page).to be_displayed
    expect(move_advisers_page.advisers[0].value).to eq(adviser.id.to_s)
    move_advisers_page.advisers[0].set(true)
    move_advisers_page.next.click
  end

  def and_i_want_to_move_to_firm(firm)
    expect(choose_firm_page).to be_displayed
    choose_firm_page.destination_firm_fca_number.set(firm.fca_number)
    choose_firm_page.next.click

    expect(choose_subsidiary_page).to be_displayed
    expect(choose_subsidiary_page.subsidiary_label(0)).to have_text(firm.registered_name)
    choose_subsidiary_page.subsidiary_field(0).set(true)
    choose_subsidiary_page.next.click
  end

  def and_adviser_is_associated_to_firm_in_the_directory(adviser, firm)
    directory_adviser = advisers_in_directory.find do |elem|
      elem['objectID'] == adviser.id
    end

    expect(directory_adviser.dig('firm', 'id')).to eq firm.id
  end

  def when_i_confirm_my_selection
    expect(confirm_page).to be_displayed

    expect(confirm_page.from_firm).to have_text(from_firm.registered_name)
    expect(confirm_page.destination_firm).to have_text(destination_firm.registered_name)
    expect(confirm_page.advisers[0]).to have_text(adviser.name)

    confirm_page.move.click
  end

  def then_the_adviser_is_moved
    expect(move_page).to be_displayed

    destination_firm.reload
    from_firm.reload
    expect(destination_firm.advisers).to include(adviser)
    expect(from_firm.advisers).not_to include(adviser)
  end

  def given_i_do_not_specify_any_advisers_to_move
    given_i_want_to_move_an_adviser_from_firm(from_firm)
    expect(move_advisers_page).to be_displayed
    move_advisers_page.next.click
  end

  def given_i_supply_a_non_existent_fca_number
    given_i_want_to_move_an_adviser_from_firm(from_firm)
    and_i_want_to_move_adviser(adviser)
    choose_firm_page.destination_firm_fca_number.set('DOES_NOT_EXIST')
    choose_firm_page.next.click
  end

  def given_i_forget_to_select_a_subsidiary
    given_i_want_to_move_an_adviser_from_firm(from_firm)
    and_i_want_to_move_adviser(adviser)

    expect(choose_firm_page).to be_displayed
    choose_firm_page.destination_firm_fca_number.set(destination_firm.fca_number)
    choose_firm_page.next.click

    expect(choose_subsidiary_page).to be_displayed
    choose_subsidiary_page.next.click
  end

  def then_i_am_told_about_the_problem_on(page)
    expect(page).to be_displayed
    expect(page).to have_validation_errors
  end
end
