Rails.application.routes.draw do
  post '/' => "questionnaire#create"
  root to: 'questionnaire#show'
end
