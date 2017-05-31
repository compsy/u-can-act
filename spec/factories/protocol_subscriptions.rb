# frozen_string_literal: true

FactoryGirl.define do
  factory :protocol_subscription do
    initialize_with { new(attributes) }
    person
    protocol
    state ProtocolSubscription::ACTIVE_STATE
    start_date Time.new(2017, 4, 10, 0, 0, 0).in_time_zone
  end
end
