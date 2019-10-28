# frozen_string_literal: true

Rails.application.routes.draw do
  post '/informed_consent' => 'questionnaire#create_informed_consent'
  get '/klaar' => 'reward#index'
  post '/' => 'questionnaire#create'
  root to: 'token_authentication#show'
  resources :mentor_overview, only: [:index]
  resources :questionnaire, only: %i[index show create destroy], param: :uuid do
    collection do
      get :interactive
      post :interactive_render
    end
  end
  resource :person, only: %i[edit update] do
    get 'unsubscribe'
  end

  get 'o', to: 'one_time_response#show', as: 'one_time_response'

  # Admin panel
  scope path: :admin do
    get '/', to: 'admin#index', as: 'admin'
    get 'export', to: 'admin#export', as: 'admin_export'
    get 'preview_overview', to: 'admin#preview_overview', as: 'admin_preview_overview'
    get 'organization_overview', to: 'admin#organization_overview', as: 'admin_organization_overview'

    get 'person_export', to: 'admin#person_export', as: 'admin_person_export'
    get 'protocol_subscription_export', to: 'admin#protocol_subscription_export', as: 'admin_protocol_subscription_export'
    get 'invitation_set_export', to: 'admin#invitation_set_export', as: 'admin_invitation_set_export'
    get 'protocol_transfer_export', to: 'admin#protocol_transfer_export', as: 'admin_protocol_transfer_export'
    get 'questionnaire_export/:id', to: 'admin#questionnaire_export', as: 'admin_questionnaire_export'
    get 'response_export/:id', to: 'admin#response_export', as: 'admin_response_export'
    get 'reward_export', to: 'admin#reward_export', as: 'admin_reward_export'
    get 'proof_of_participation_export', to: 'admin#proof_of_participation_export', as: 'admin_proof_of_participation_export'

    post 'preview', to: 'admin#preview', as: 'admin_preview'
    get 'preview', to: 'admin#preview', as: 'admin_preview_get'
    post 'preview_done', to: 'admin#preview_done', as: 'admin_preview_done'
    get '*path', to: 'admin#index'
  end

  # Static pages
  get 'disclaimer', to: 'static_pages#disclaimer', as: 'disclaimer'

  # Status
  get '/status' => 'status#show'

  namespace :api do
    namespace :v1 do
      resources :questionnaire, only: [:show, :create], param: :key
      resources :response, only: [:show, :index, :create], param: :uuid
      resources :people, only: [:create], param: :external_identifier
      resources :auth_user, only: [:create]
      resources :person, only: [:update] do
        collection do
          get :me
        end
      end
      resources :statistics, only: [:index]
      resources :settings, only: [:index]
      resources :protocol_subscriptions, only: [:show]
      namespace :admin do
        resources :team, only: [:show], param: :group
        resources :organization, only: [:show], param: :group
      end
    end
  end
  match '/',
        controller: 'application',
        action: 'options',
        constraints: { method: %w[OPTIONS POST PUT PATCH DELETE] },
        via: %i[options post put patch delete]
  match '*path', via: :all, to: redirect('/404.html')
end
