# frozen_string_literal: true

FactoryGirl.define do
  factory :measurement do
    questionnaire
    protocol
    open_from_offset((1.day + 13.hours).to_i) # Tuesday 1pm
    open_duration 2.hours.to_i
    reward_points 10

    trait :periodical do
      period 1.week.to_i
    end
    trait :relative_to_end_date do
      open_from_offset((- 2.days - 11.hours).to_i) # Friday 1pm
    end
  end
end
