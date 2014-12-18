Rails.application.routes.draw do
  root 'principals#pre_qualification_form'

  resource :principal do
    get 'prequalify', action: 'pre_qualification_form'
    post 'prequalify', action: 'pre_qualification'

    get 'identify', action: 'identification_form'

    get 'rejection', action: 'rejection_form'
  end

  resource :contact, only: :create
end
