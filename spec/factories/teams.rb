# frozen_string_literal: true

FactoryBot.define do
  sequence(:team_name) { |n| "team-#{n}" }
  factory :team do
    name { generate(:team_name) }
    organization

    trait :with_roles do
      after(:create) do |team|
        FactoryBot.create(:role, group: Person::STUDENT, title: 'Studenttitle', team: team)
        FactoryBot.create(:role, group: Person::MENTOR, title: 'Mentortitle', team: team)
      end
    end
  end
end
