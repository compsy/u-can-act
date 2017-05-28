Rails.application.routes.draw do
  post '/informed_consent' => 'questionnaire#create_informed_consent'
  get '/klaar' => 'reward#show'
  post '/' => 'questionnaire#create'
  root to: 'questionnaire#show'
end
