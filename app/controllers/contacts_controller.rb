class ContactsController < ApplicationController
  def create
    @message = ContactForm.new(contact_params)

    if @message.valid?
      deliver_message_later
      redirect_to reject_retirement_advice_registrations_path, notice: t('rejection.contact_sent')
    else
      render 'retirement_advice_registrations/rejection_form'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :message)
  end

  def deliver_message_later
    AdminContact.contact(
      params[:contact][:email],
      params[:contact][:message]
    ).deliver_later

    Stats.increment('radsignup.contact.sent')
  end
end
