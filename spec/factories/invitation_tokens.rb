# frozen_string_literal: true

FactoryBot.define do
  factory :invitation_token do
    invitation_set
    token '1234'
    expires_at 7.days.from_now.in_time_zone
  end
end
