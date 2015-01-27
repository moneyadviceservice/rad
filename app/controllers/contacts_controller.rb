class ContactsController < ApplicationController
  before_action :authenticate, except: [:create]

  def create
    @message = ContactForm.new(params[:contact])

    if @message.valid?
      AdminContact.contact(
        params[:contact][:email],
        params[:contact][:message]
      ).deliver_later

      Stats.increment('radsignup.contact.sent')

      redirect_to reject_principals_path, notice: t('rejection.contact_sent')
    else
      render 'principals/rejection_form'
    end
  end
end
