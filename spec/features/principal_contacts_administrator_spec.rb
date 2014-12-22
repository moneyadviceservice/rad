RSpec.feature 'Principal contacts Administrator' do
  let(:rejection_page) { RejectionPage.new }

  scenario 'Sending a valid message' do
    given_i_have_failed_pre_qualification
    when_i_submit_my_message
    then_my_message_is_sent_to_the_administrator
    and_i_am_notified
  end

  scenario 'Attempting to send an invalid message' do
    given_i_have_failed_pre_qualification
    when_i_attempt_to_submit_an_empty_message
    then_i_am_told_to_provide_a_message
  end


  def given_i_have_failed_pre_qualification
    rejection_page.load
  end

  def when_i_submit_my_message
    rejection_page.tap do |p|
      p.principal_email.set 'dave@example.com'
      p.administrator_message.set 'Send help'
      p.send_message.click
    end
  end

  def then_my_message_is_sent_to_the_administrator
    expect(ActionMailer::Base.deliveries).not_to be_empty
  end

  def and_i_am_notified
    expect(rejection_page).to have_content('Your message has been sent')
  end

  def when_i_attempt_to_submit_an_empty_message
    rejection_page.send_message.click
  end

  def then_i_am_told_to_provide_a_message
    expect(rejection_page).to_not be_valid
  end
end
