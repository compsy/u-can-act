# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    auth0_id_string
    password_digest 'MyString'
  end
end
