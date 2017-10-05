Rails.application.routes.draw do
  post '/informed_consent' => 'questionnaire#create_informed_consent'
  get '/klaar' => 'reward#show'
  post '/' => "questionnaire#create"
  root to: 'token_authentication#show'
  resources :mentor_overview, only: [:index]
  resources :questionnaire, only: [:show, :create], param: :q

  # Admin panel
  get 'admin', to: 'admin#index'
  get 'admin/person_export', to: 'admin#person_export'
  get 'admin/protocol_subscription_export', to: 'admin#protocol_subscription_export'
  get 'admin/questionnaire_export/:id', to: 'admin#questionnaire_export', as: 'admin_questionnaire_export'
  get 'admin/response_export/:id', to: 'admin#response_export', as: 'admin_response_export'

  namespace :api do
    namespace :v1 do
      get 'rewards/:id', to: 'rewards#show'
    end
  end
end
