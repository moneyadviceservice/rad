RSpec.feature 'Firm login report' do

  scenario 'View login report' do
    given_there_are_users
    when_i_view_the_login_report
    then_i_can_see_who_has_accepted_an_invitation
  end

  def when_i_view_the_login_report
    visit login_report_admin_firms_path
  end

  def then_i_can_see_who_has_accepted_an_invitation
    within('#accepted') do
      expect(page).to have_content(@first_user.principal.firm.registered_name)
      expect(page).to have_content(@second_user.principal.firm.registered_name)
      expect(page).to_not have_content(@third_user.principal.firm.registered_name)
      expect(page).to_not have_content(@fourth_user.principal.firm.registered_name)
    end
  end

  def and_i_can_see_who_has_not_accepted_an_invitation
    within('#pending') do
      expect(page).to_not have_content(@first_user.principal.firm.registered_name)
      expect(page).to_not have_content(@second_user.principal.firm.registered_name)
      expect(page).to have_content(@third_user.principal.firm.registered_name)
      expect(page).to have_content(@fourth_user.principal.firm.registered_name)
    end
  end

  private

  def create_user_with_firm(user_attrs, firm_attrs = {})
    principal = FactoryBot.create(:principal)
    firm_attrs = FactoryBot.attributes_for(
      :firm_with_trading_names,
      fca_number: principal.fca_number
    ).merge(firm_attrs)

    principal.firm.update_attributes!(firm_attrs)

    FactoryBot.create :user, { principal: principal }.merge(user_attrs)
  end

  def given_there_are_users
    @first_user = create_user_with_firm(
      { invitation_accepted_at: Time.zone.today }, registered_name: 'Delta'
    )

    @second_user = create_user_with_firm(
      { invitation_accepted_at: Time.zone.today }, registered_name: 'Alpha'
    )

    @third_user = create_user_with_firm(
      { invitation_accepted_at: nil }, registered_name: 'Gamma'
    )

    @fourth_user = create_user_with_firm(
      { invitation_accepted_at: nil }, registered_name: 'Charlie'
    )
  end
end

