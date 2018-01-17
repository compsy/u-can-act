# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    group 'Student'
    title 'The title'
    organization
  end
end
