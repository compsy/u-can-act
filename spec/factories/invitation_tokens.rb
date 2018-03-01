# frozen_string_literal: true

FactoryBot.define do
  sequence(:token) { |n| "abcd#{format('%04d', n)}" }
  factory :invitation_token do
    invitation_set
    token
    expires_at 7.days.from_now.in_time_zone
  end
end
