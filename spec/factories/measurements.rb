# frozen_string_literal: true

FactoryGirl.define do
  factory :measurement do
    questionnaire
    protocol
    open_from_offset(1.day + 13.hours) # Tuesday 1pm
    open_duration 2.hours
    reward_points 1

    trait :periodical do
      period 1.week
    end
  end
end
