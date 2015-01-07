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
      resource :questionnaire, only: [] do
        collection do
          get 'step-1', action: 'step_1_form'
        end
      end
    end
  end

  resource :contact, only: :create
end
