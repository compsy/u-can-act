# frozen_string_literal: true

FactoryBot.define do
  sequence(:organization_name) { |n| "organization-#{n}" }
  factory :organization do
    name { generate(:organization_name) }
  end
end
