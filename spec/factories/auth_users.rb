# frozen_string_literal: true

FactoryBot.define do
  sequence(:auth0_id_string) { |n| "id_#{format('%10d', n)}" }
  factory :auth_user do
    auth0_id_string
    password_digest 'thepasswordwhicisrandom'
    role 'user'
    person nil

    trait :with_person do
      person
    end
  end
end
