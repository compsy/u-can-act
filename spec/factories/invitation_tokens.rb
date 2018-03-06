# frozen_string_literal: true

FactoryBot.define do
  factory :invitation_token do
    # TODO: initialize_with { new(attributes) } ?
    invitation_set
    # TODO: the two props below are not needed if initialized?
    token '1234'
    expires_at 7.days.from_now.in_time_zone
  end
end
