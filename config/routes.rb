Rails.application.routes.draw do
  post '/' => "questionnaire#create"
  #root to: 'questionnaire#show'
  root to: 'token_authentication#show'
  resources :mentor_overviews, only: [:show], param: :q
  resources :questionnaires, only: [:show, :create], param: :q
end
