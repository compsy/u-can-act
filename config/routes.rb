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
  post 'admin/preview', to: 'admin#preview', as: 'admin_preview'
  post 'admin/preview_done', to: 'admin#preview_done', as: 'admin_preview_done'

  # Static pages
  get 'disclaimer', to: 'static_pages#disclaimer', as: 'disclaimer'

  # Status
  get '/status' => 'status#show'

  namespace :api do
    namespace :v1 do
      get 'protocol_subscriptions/:id', to: 'protocol_subscriptions#show'
      get 'statistics', to: 'statistics#index'
    end
  end
end
