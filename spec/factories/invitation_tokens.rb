# frozen_string_literal: true

FactoryBot.define do
  factory :invitation_token do
    response
    token '1234'
  end
end
