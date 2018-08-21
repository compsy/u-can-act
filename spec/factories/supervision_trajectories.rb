# frozen_string_literal: true

FactoryBot.define do
  sequence(:name) { |n| "name-#{n}" }
  factory :supervision_trajectory do
    name
    protocol_for_mentor nil
    protocol_for_student nil

    trait :with_protocol_for_mentor do
      protocol_for_mentor
    end

    trait :with_protocol_for_student do
      protocol_for_mentor
    end
  end
end
