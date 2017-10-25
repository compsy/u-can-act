# frozen_string_literal: true

FactoryGirl.define do
  sequence(:organization_name) { |n| "organisatie-#{n}" }
  factory :organization do
    name { generate(:organization_name) }
    mentor_title 'begeleider'
  end
end
