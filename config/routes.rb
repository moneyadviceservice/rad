Rails.application.routes.draw do
  root 'principals#pre_qualification_form'

  get 'error', to: 'pages#error'

  resources :principals, param: :token do
    collection do
      get 'prequalify',  action: 'pre_qualification_form'
      post 'prequalify', action: 'pre_qualification'
      get 'reject',      action: 'rejection_form'
    end

    resource :firm, only: :show do
      resource :questionnaire, only: [:show, :update]
      resources :advisers
    end
  end

  resource :contact, only: :create
end
