# frozen_string_literal: true

FactoryBot.define do
  sequence(:title) { |n| "title-#{n}" }
  factory :role do
    group 'Student'
    title
    team

    trait :student do
      group 'Student'
    end

    trait :mentor do
      group 'Mentor'
    end
  end
end
