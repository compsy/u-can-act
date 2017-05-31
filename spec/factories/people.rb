# frozen_string_literal: true

FactoryGirl.define do
  sequence(:mobile_phone) { |n| "06#{format('%08d', n)}" }
  factory :person do
    mobile_phone
    first_name 'Jane'
    last_name 'Doe'
    type 'Person'

    trait :with_protocol_subscriptions do
      after(:create) do |person|
        FactoryGirl.create(:protocol_subscription, person: person)
      end
    end
  end

  factory :mentor, class: 'Mentor', parent: :person do
    type 'Mentor'
  end

  factory :student, class: 'Student', parent: :person do
    type 'Student'
  end
end
