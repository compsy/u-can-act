# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    # TODO: initialize_with { new(attributes) } ?
    protocol_subscription
    measurement
    open_from Time.new(2017, 4, 10, 9, 0, 0).in_time_zone
    trait :completed do
      content { create(:response_content).id }
      opened_at Time.new(2017, 4, 10, 9, 2, 36).in_time_zone
      completed_at Time.new(2017, 4, 10, 9, 7, 6).in_time_zone
      invitation_set
    end
    trait :future do
      open_from 10.days.from_now
    end
    trait :invited do
      after(:create) do |response|
        FactoryBot.create(:invitation_set, responses: [response], person_id: response.protocol_subscription.person_id)
      end
    end
    # trait :reminder_sent do
    #  invited_state Response::REMINDER_SENT_STATE
    # end
    trait :periodical do
      after(:create) do |response|
        FactoryBot.create(:measurement, responses: [response], period: 1)
      end
    end
  end
end
