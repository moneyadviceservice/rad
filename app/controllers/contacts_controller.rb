class ContactsController < ApplicationController
  before_action :authenticate, except: [:create]

  def create
    if ContactForm.new(params[:contact]).valid?
      AdminContact.perform_async(
        params[:contact][:email],
        params[:contact][:message]
      )
      head :ok
    else
      head :bad_request
    end
  end
end
