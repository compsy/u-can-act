# frozen_string_literal: true

FactoryBot.define do
  factory :protocol_subscription do
    # TODO: try removing?
    initialize_with { new(attributes) }
    person
    protocol
    state ProtocolSubscription::ACTIVE_STATE
    start_date Time.new(2017, 4, 10, 0, 0, 0).in_time_zone

    trait :mentor do
      filling_out_for { create(:person) }
    end
  end
end
