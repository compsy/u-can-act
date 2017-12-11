# frozen_string_literal: true

FactoryGirl.define do
  sequence(:protocol_name) { |n| "dagboekstudie-studenten-#{n}" }
  factory :protocol do
    name { generate(:protocol_name) }
    duration 3.weeks
    trait :with_informed_consent_questionnaire do
      association :informed_consent_questionnaire,
                  factory: :questionnaire,
                  name: 'Informed Consent',
                  title: 'Informed Consent',
                  content: [{
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

  trait :with_rewards do
    after(:create) do |protocol|
      FactoryGirl.create(:reward, threshold: 1, reward_points: 100,  protocol: protocol)
      FactoryGirl.create(:reward, threshold: 5, reward_points: 300,  protocol: protocol)
      FactoryGirl.create(:reward, threshold: 7, reward_points: 500,  protocol: protocol)
    end
  end

  trait :with_student_rewards do
    after(:create) do |protocol|
      FactoryGirl.create(:reward, threshold: 1, reward_points: 2,  protocol: protocol)
      FactoryGirl.create(:reward, threshold: 3, reward_points: 3,  protocol: protocol)
    end
  end
end
