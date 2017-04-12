# frozen_string_literal: true

FactoryGirl.define do
  factory :person do
    mobile_phone '0612345678'
    type 'Person'

    trait :student do
      type 'Student'
    end
    trait :mentor do
      type 'Mentor'
    end
  end
end
