RSpec.feature 'Move advisers between firms' do
  let(:adviser) { create(:adviser) }
  let(:from_firm) { create(:firm_with_principal, advisers: [adviser]) }
  let(:to_firm) { create(:firm) }
  let(:firm_page) { Admin::FirmPage.new }
  let(:move_advisers_page) { Admin::MoveAdvisers::MoveAdvisersPage.new }
  let(:choose_firm_page) { Admin::MoveAdvisers::ChooseFirmPage.new }
  let(:choose_subsidiary_page) { Admin::MoveAdvisers::ChooseSubsidiaryPage.new }
  let(:confirm_page) { Admin::MoveAdvisers::ConfirmPage.new }
  let(:move_page) { Admin::MoveAdvisers::MovePage.new }

  scenario 'Moving an adviser from one firm to another' do
    given_i_want_to_move_an_adviser_from_firm(from_firm)
    and_i_want_to_move_adviser(adviser)
    and_i_want_to_move_to_firm(to_firm)
    when_i_confirm_my_selection
    then_the_adviser_is_moved
  end

  scenario 'When no advisers are selected to move' do
    given_i_do_not_specify_any_advisers_to_move
    then_i_am_told_about_the_problem
  end

  def given_i_want_to_move_an_adviser_from_firm(firm)
    firm_page.load(firm_id: firm.id)
    expect(firm_page).to be_displayed
    firm_page.move_advisers.click
  end

  def and_i_want_to_move_adviser(adviser)
    expect(move_advisers_page).to be_displayed
    move_advisers_page.advisers[0].set(true)
    move_advisers_page.next.click
  end

  def and_i_want_to_move_to_firm(firm)
    expect(choose_firm_page).to be_displayed
    expect(choose_firm_page.hidden.advisers[0].value).to eq(adviser.id.to_s)
    choose_firm_page.to_firm_fca_number.set(to_firm.fca_number)
    choose_firm_page.next.click

    expect(choose_subsidiary_page).to be_displayed
    expect(choose_subsidiary_page.hidden.advisers[0].value).to eq(adviser.id.to_s)
    expect(choose_subsidiary_page.subsidiary_label(0))
      .to have_text(to_firm.registered_name)
    choose_subsidiary_page.subsidiary_field(0).set(true)
    choose_subsidiary_page.next.click
  end

  def when_i_confirm_my_selection
    expect(confirm_page).to be_displayed

    expect(confirm_page.hidden.advisers[0].value).to eq(adviser.id.to_s)
    expect(confirm_page.hidden.to_firm_id.value).to eq(to_firm.id.to_s)

    expect(confirm_page.from_firm).to have_text(from_firm.registered_name)
    expect(confirm_page.to_firm).to have_text(to_firm.registered_name)
    expect(confirm_page.advisers[0]).to have_text(adviser.name)

    confirm_page.move.click
  end

  def then_the_adviser_is_moved
    expect(move_page).to be_displayed

    to_firm.reload
    from_firm.reload
    expect(to_firm.advisers).to include(adviser)
    expect(from_firm.advisers).not_to include(adviser)
  end

  def given_i_do_not_specify_any_advisers_to_move
    given_i_want_to_move_an_adviser_from_firm(from_firm)
    expect(move_advisers_page).to be_displayed
    move_advisers_page.next.click
  end

  def then_i_am_told_about_the_problem
    # TODO this is confusing: the next URL is shown but the old view is rendered
    expect(choose_firm_page).to be_displayed
    expect(choose_firm_page).to have_validation_errors
  end
end
