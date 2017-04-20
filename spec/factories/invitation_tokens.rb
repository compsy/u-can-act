# frozen_string_literal: true

FactoryGirl.define do
  sequence(:token) { |n| "secure-random-hex-#{n}" }
  factory :invitation_token do
    response
    token
  end
end
