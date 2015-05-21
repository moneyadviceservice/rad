require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  root 'principals#pre_qualification_form'

  get 'error', to: 'pages#error'

  resources :principals, param: :token do
    collection do
      get 'prequalify',  action: 'pre_qualification_form'
      post 'prequalify', action: 'pre_qualification'
      get 'reject',      action: 'rejection_form'
    end

    resources :firms, only: :index do
      resource :questionnaire, only: [:edit, :update]
      resources :advisers
      resources :subsidiaries, only: [] do
        member do
          post 'convert'
        end
      end
    end

    namespace :lookup do
      resources :advisers, only: :show
    end
  end

  namespace :dashboard do
    root 'dashboard#index'
  end

  resource :contact, only: :create

  namespace :admin do
    root 'pages#home'
    resources :advisers, only: [:index, :show, :edit, :update, :destroy]

    resources :firms, only: [:index, :show] do
      resources :advisers, only: :index
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
    resources :principals, only: [:index, :show, :edit, :update]
  end

  if HttpAuthentication.required?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      HttpAuthentication.authenticate(username, password)
    end

    mount Sidekiq::Web, at: '/sidekiq'
  end
end
