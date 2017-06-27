class ContactsController < ApplicationController
  def create
    @message = ContactForm.new(params[:contact])

    if @message.valid?
      deliver_message_later
      redirect_to reject_principals_path, notice: t('rejection.contact_sent')
    else
      render 'principals/rejection_form'
    end
  end

  private

  def deliver_message_later
    AdminContact.contact(
      params[:contact][:email],
      params[:contact][:message]
    ).deliver_later

    Stats.increment('radsignup.contact.sent')
  end
end
