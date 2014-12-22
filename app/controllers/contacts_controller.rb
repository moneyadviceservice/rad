class ContactsController < ApplicationController
  def create
    @message = ContactForm.new(params[:contact])

    if @message.valid?
      AdminContactWorker.perform_async(
        params[:contact][:email],
        params[:contact][:message]
      )

      redirect_to reject_principals_path, notice: t('rejection.contact_sent')
    else
      render 'principals/rejection_form'
    end
  end
end
