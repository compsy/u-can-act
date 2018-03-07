# frozen_string_literal: true

FactoryBot.define do
  sequence(:organization_name) { |n| "organization-#{n}" }
  factory :organization do
    name { generate(:organization_name) }

    trait :with_teams do
      after(:create) do |organization|
        FactoryBot.create(:team, organization: organization)
        FactoryBot.create(:team, organization: organization)
      end
    end
  end
end
