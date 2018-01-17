Rails.application.routes.draw do
  post '/informed_consent' => 'questionnaire#create_informed_consent'
  get '/klaar' => 'reward#show'
  post '/' => "questionnaire#create"
  root to: 'token_authentication#show'
  resources :mentor_overview, only: [:index]
  resources :questionnaire, only: [:show, :create], param: :q

  # Admin panel
  scope path: :admin do
    get '/', to: 'admin#index', as: 'admin'
    get 'person_export', to: 'admin#person_export', as: 'admin_person_export'
    get 'protocol_subscription_export', to: 'admin#protocol_subscription_export', as: 'admin_protocol_subscription_export'
    get 'questionnaire_export/:id', to: 'admin#questionnaire_export', as: 'admin_questionnaire_export'
    get 'response_export/:id', to: 'admin#response_export', as: 'admin_response_export'
    post 'preview', to: 'admin#preview', as: 'admin_preview'
    post 'preview_done', to: 'admin#preview_done', as: 'admin_preview_done'
  end

  # Static pages
  get 'disclaimer', to: 'static_pages#disclaimer', as: 'disclaimer'

  # Status
  get '/status' => 'status#show'

  namespace :api do
    namespace :v1 do
      get 'protocol_subscriptions/:id', to: 'protocol_subscriptions#show'
      namespace :admin do
        resources :organization, only: [:show], param: :group
      end
    end
  end

  get '*path', to: 'admin#index'
end
