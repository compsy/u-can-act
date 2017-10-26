# frozen_string_literal: true

FactoryGirl.define do
  factory :role do
    group 'Student'
    title 'The title'
    organization
  end
end
