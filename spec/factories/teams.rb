# frozen_string_literal: true

FactoryBot.define do
  sequence(:team_name) { |n| "organisatie-#{n}" }
  factory :team do
    name { generate(:team_name) }

    trait :with_roles do
      after(:create) do |team|
        FactoryBot.create(:role, group: Person::STUDENT, title: 'Studenttitle', team: team)
        FactoryBot.create(:role, group: Person::MENTOR, title: 'Mentortitle', team: team)
      end
    end
  end
end
