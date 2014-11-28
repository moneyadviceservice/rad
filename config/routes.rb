Rails.application.routes.draw do
  root 'pages#home'

  scope controller: :registration do
    get 'prequalification', action: 'pre_qualification_form'
    post 'prequalification', action: 'pre_qualification'
    get 'verification', action: 'verification_form'
  end
end
