# frozen_string_literal: true

FactoryGirl.define do
  sequence(:title) { |n| "title-#{n}" }
  factory :role do
    group 'Student'
    title
    organization
  end
end
