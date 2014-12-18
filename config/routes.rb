Rails.application.routes.draw do
  root 'principals#pre_qualification_form'

  resource :principal do
    get 'prequalify', action: 'pre_qualification_form'
    post 'prequalify', action: 'pre_qualification'
    get 'reject', action: 'rejection_form'

    get 'identify', action: 'identification_form'
  end

  resource :contact, only: :create
end
