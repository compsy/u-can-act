# frozen_string_literal: true

FactoryBot.define do
  sequence(:auth0_id_string) { |n| "id_#{format('%10d', n)}" }
  factory :admin do
    auth0_id_string
    password_digest 'MyString'
  end
end
