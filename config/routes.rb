require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  devise_for :users

  unauthenticated do
    root 'principals#pre_qualification_form'
  end

  authenticated do
    # This root is given an explicit name to prevent a root route name collision
    root to: redirect('/self_service/'), as: :authenticated_root
  end

  get 'error', to: 'pages#error'

  resources :principals, param: :token do
    collection do
      get 'prequalify',  action: 'pre_qualification_form'
      post 'prequalify', action: 'pre_qualification'
      get 'reject',      action: 'rejection_form'
    end
  end

  namespace :lookup do
    resources :advisers, only: :show
  end

  namespace :self_service do
    root to: redirect('/self_service/firms')
    resources :trading_names, only: [:new, :create, :edit, :update, :destroy]
    resources :principals, only: [:edit, :update]

    resources :firms, only: [:index, :edit, :update] do
      resources :advisers, except: [:show]
      resources :offices, except: [:show]
    end
  end

  resource :contact, only: :create

  namespace :admin do
    root 'pages#home'

    post '/users/sign_in', to: 'users#switch_user'

    resources :advisers, only: [:index, :show, :edit, :update, :destroy]

    resources :firms, only: [:index, :show] do
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
    end
    resources :principals, only: [:index, :show, :destroy]

    namespace :reports do
      resources :metrics, only: [:index, :show] do
        member do
          get :download
        end
      end
      resource :inactive_adviser, only: [:show]
    end
  end

  if HttpAuthentication.required?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      HttpAuthentication.authenticate(username, password)
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
