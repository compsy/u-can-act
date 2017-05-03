# frozen_string_literal: true

FactoryGirl.define do
  factory :response do
    protocol_subscription
    measurement
    open_from Time.new(2017, 4, 10, 9, 0, 0).in_time_zone
    invited_state Response::NOT_SENT_STATE
    trait :completed do
      content { create(:response_content).id }
      opened_at Time.new(2017, 4, 10, 9, 2, 36).in_time_zone
      completed_at Time.new(2017, 4, 10, 9, 7, 6).in_time_zone
      invited_state Response::SENT_STATE
    end
  end
end
