# frozen_string_literal: true

FactoryBot.define do
  sequence(:title) { |n| "title-#{n}" }
  factory :role do
    group 'Student'
    title
    team
  end
end
