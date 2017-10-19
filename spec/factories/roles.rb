# frozen_string_literal: true

FactoryGirl.define do
  factory :role do
    group 'The group'
    title 'The title'
    organization
  end
end
