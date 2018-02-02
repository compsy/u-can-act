# frozen_string_literal: true

FactoryBot.define do
  sequence(:organization_name) { |n| "organisatie-#{n}" }
  factory :organization do
    name { generate(:organization_name) }

    trait :with_roles do
      after(:create) do |organization|
        FactoryBot.create(:role, group: Person::STUDENT, title: 'Studenttitle', organization: organization)
        FactoryBot.create(:role, group: Person::MENTOR, title: 'Mentortitle', organization: organization)
      end
    end
  end
end
