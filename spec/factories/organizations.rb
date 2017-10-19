# frozen_string_literal: true

FactoryGirl.define do
  sequence(:organization_name) { |n| "organisatie-#{n}" }
  factory :organization do
    name { generate(:organization_name) }
    mentor_title 'begeleider'

    trait :with_roles do
      after(:create) do |organization|
        FactoryGirl.create(:role, group: 'Student', title: 'Studenttitle', organization: organization)
        FactoryGirl.create(:role, group: 'Mentor', title: 'Mentortitle', organization: organization)
      end
    end
  end
end
