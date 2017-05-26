Rails.application.routes.draw do
  get '/klaar' => 'reward#show'
  post '/' => "questionnaire#create"
  root to: 'questionnaire#show'
end
