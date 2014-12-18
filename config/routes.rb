Rails.application.routes.draw do
  root 'principals#pre_qualification_form'

  get 'error', to: 'pages#error'

  resource :principal do
    get 'prequalify', action: 'pre_qualification_form'
    post 'prequalify', action: 'pre_qualification'

    get 'identify', action: 'identification_form'
  end

  resource :contact, only: :create
  resources :firms, only: :index
end
