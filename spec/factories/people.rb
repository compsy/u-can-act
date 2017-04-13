# frozen_string_literal: true

FactoryGirl.define do
  sequence(:mobile_phone) { |n| "06#{format('%08d', n)}" }
  factory :person do
    mobile_phone
    type 'Person'

    trait :student do
      type 'Student'
    end
    trait :mentor do
      type 'Mentor'
    end
    trait :with_protocol_subscriptions do
      after(:create) do |person|
        FactoryGirl.create(:protocol_subscription, person: person)
      end
    end
  end
end
