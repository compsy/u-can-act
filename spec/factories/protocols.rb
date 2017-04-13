# frozen_string_literal: true

FactoryGirl.define do
  sequence(:protocol_name) { |n| "dagboekstudie-studenten-#{n}" }
  factory :protocol do
    name { generate(:protocol_name) }
    duration 3.weeks
  end

  trait :with_measurements do
    after(:create) do |protocol|
      FactoryGirl.create(:measurement, protocol: protocol)
    end
  end
end
