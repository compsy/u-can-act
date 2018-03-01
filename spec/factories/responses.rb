# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    protocol_subscription
    measurement
    # invitation_set nil
    open_from Time.new(2017, 4, 10, 9, 0, 0).in_time_zone
    # invited_state Response::NOT_SENT_STATE
    trait :completed do
      content { create(:response_content).id }
      opened_at Time.new(2017, 4, 10, 9, 2, 36).in_time_zone
      completed_at Time.new(2017, 4, 10, 9, 7, 6).in_time_zone
      # invited_state Response::SENT_STATE
    end
    trait :future do
      open_from 10.days.from_now
    end
    # trait :invite_sent do
    #  invited_state Response::SENT_STATE
    # end
    # trait :reminder_sent do
    #  invited_state Response::REMINDER_SENT_STATE
    # end
    # trait :with_invitation_token do
    # invited_state Response::SENT_STATE
    # invitation_token
    # end
    trait :periodical do
      after(:create) do |response|
        FactoryBot.create(:measurement, responses: [response], period: 1)
      end
    end
  end
end
