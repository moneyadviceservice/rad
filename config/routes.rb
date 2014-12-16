Rails.application.routes.draw do
  root 'pages#home'

  resource :principal do
    get 'prequalify', action: 'pre_qualification_form'
    post 'prequalify', action: 'pre_qualification'

    get 'identify', action: 'identification_form'
  end

  resource :contact, only: :create
end
