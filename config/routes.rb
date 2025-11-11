require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  get '/422', to: 'errors#unprocessable_entity'

  if Rails.env.staging?
    mount Lockup::Engine, at: '/lockup'
  end

  unauthenticated do
    root 'retirement_advice_registrations#pre_qualification_form'
  end

  authenticated do
    # This root is given an explicit name to prevent a root route name collision
    root to: redirect('/self_service/'), as: :authenticated_root
  end

  get 'error', to: 'pages#error'

  resources :retirement_advice_registrations, param: :token do
    collection do
      get 'prequalify',  action: 'pre_qualification_form'
      post 'prequalify', action: 'pre_qualification'
      get 'reject',      action: 'rejection_form'
    end
  end

  resources :travel_insurance_registrations, only: [:new, :create] do
    collection do
      [:risk_profile, :medical_conditions, :medical_conditions_questionaire].each do |action_name|
        get action_name,  action: "wizard_form", defaults: { current_step: action_name }, constraints: { current_step: action_name }
        post action_name, action: "wizard", defaults: { current_step: action_name }, constraints: { current_step: action_name }
      end
      get 'reject',      action: 'rejection_form'
    end
  end

  namespace :lookup do
    resources :advisers, only: :show
  end

  namespace :self_service do
    root to: 'base#choose_firm_type'
    resources :trading_names, only: [:new, :create, :edit, :update, :destroy]
    resources :travel_insurance_trading_names, only: [:new, :create, :edit, :update, :destroy]
    resources :principals, only: [:edit, :update]

    resources :firms, only: [:index, :edit, :update] do
      resources :advisers, except: [:show]
      resources :offices, except: [:show], defaults: { firm_type: 'Firm' }
    end

    resources :travel_insurance_firms, only: [:index, :edit, :update] do
      resources :offices, except: [:show], controller: 'travel_insurance_offices'
    end

    resources :travel_insurance_reregistrations, only: [:new, :create] do
      collection do
        [:risk_profile, :medical_conditions, :medical_conditions_questionaire].each do |action_name|
          get action_name,  action: "wizard_form", defaults: { current_step: action_name }, constraints: { current_step: action_name }
          post action_name, action: "wizard", defaults: { current_step: action_name }, constraints: { current_step: action_name }
        end
        get 'reject',      action: 'rejection_form'
      end
    end
  end

  resource :contact, only: :create

  namespace :admin do
    root 'pages#home', as: :root

    post '/users/:user_id/sign_in', to: 'user_sessions#create', as: :user_session

    resources :advisers, only: [:index, :show, :edit, :update, :destroy]

    resources :travel_insurance_firms, only: [:index, :show] do
      post :reregister_approve
      post :approve
      post :hide
    end

    resources :travel_insurance_principals do
      resource :user, only: [:edit, :update]
    end

    resources :retirement_firms, only: [:index, :show] do
      post :approve

      collection do
        get :login_report
        get :adviser_report
      end

      resources :advisers, only: [:index, :new, :create]
      member do
        resources :move_advisers, only: [:new] do
          collection do
            get :choose_destination_firm
            get :choose_subsidiary
            get :confirm
            post :move
          end
        end
      end
    end
    namespace :lookup do
      resources :advisers, only: :index
      resources :firms, only: :index
      resources :subsidiaries, only: :index
      resources :fca_import, only: [:index, :create, :update]
    end
    resources :retirement_principals, except: [:new, :create] do
      resource :user, only: [:edit, :update]
    end

    namespace :reports do
      resources :metrics, only: [:index, :show] do
        member do
          get :download
        end
      end
      resource :inactive_adviser, only: [:show]
      resources :registered_adviser, only: [:index]
      resource :inactive_firm, only: [:show]
      resources :api_inactive_firms, only: [:index]
      resource :inactive_trading_name, only: [:show]
      resources :out_of_date_firms, only: [:index, :update]
    end
  end

  if HttpAuthentication.required?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      HttpAuthentication.authenticate(username, password)
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
