# frozen_string_literal: true

FactoryBot.define do
  factory :basic_auth_session do
    initialize_with do
      new(username: 'some_username',
          password: 'some_password',
          microservice_host: 'http://microservice.dev')
    end
  end
end
