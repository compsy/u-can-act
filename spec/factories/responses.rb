# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    initialize_with { new(attributes) } # This makes it so that after_initialize blocks in the model are called.
    protocol_subscription
    measurement
    open_from Time.new(2017, 4, 10, 9, 0, 0).in_time_zone
    trait :completed do
      content { create(:response_content).id }
      after(:create) do |response|
        FactoryBot.create(:invitation_set, responses: [response], person_id: response.protocol_subscription.person_id)
        response.complete!
      end
    end
    trait :future do
      open_from 10.days.from_now
    end
    trait :invited do
      after(:create) do |response|
        FactoryBot.create(:invitation_set, responses: [response], person_id: response.protocol_subscription.person_id)
      end
    end
    trait :periodical do
      after(:create) do |response|
        FactoryBot.create(:measurement, responses: [response], period: 1)
      end
    end
  end
end
