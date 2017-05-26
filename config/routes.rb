Rails.application.routes.draw do
  post '/' => 'questionnaire#create'
  post '/informed_consent' => 'questionnaire#create_informed_consent'
  root to: 'questionnaire#show'
end
