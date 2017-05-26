# frozen_string_literal: true

FactoryGirl.define do
  sequence(:protocol_name) { |n| "dagboekstudie-studenten-#{n}" }
  factory :protocol do
    name { generate(:protocol_name) }
    duration 3.weeks
    trait :with_informed_consent_questionnaire do
      association :informed_consent_questionnaire, factory: :questionnaire, name: 'Informed Consent', content: [{
        type: :raw,
        content: '<p class="flow-text">Geef toestemming bla bla</p>'
      }]
    end
  end

  trait :with_measurements do
    after(:create) do |protocol|
      FactoryGirl.create(:measurement, protocol: protocol)
    end
  end

  trait :with_protocol_subscriptions do
    after(:create) do |protocol|
      FactoryGirl.create(:protocol_subscription, protocol: protocol)
    end
  end
end
