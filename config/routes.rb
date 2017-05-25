Rails.application.routes.draw do
  post '/' => "questionnaire#create"
  #root to: 'questionnaire#show'
  root to: 'token_authentication#show'
  resources :mentor_overview, only: [:show], param: :q
  resources :questionnaire, only: [:show, :create], param: :q
end
