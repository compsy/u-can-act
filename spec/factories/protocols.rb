# frozen_string_literal: true

FactoryBot.define do
  sequence(:protocol_name) { |n| "dagboekstudie-studenten-#{n}" }
  factory :protocol do
    name { generate(:protocol_name) }
    duration { 3.weeks }
    trait :with_informed_consent_questionnaire do
      association :informed_consent_questionnaire,
                  factory: :questionnaire,
                  title: 'Informed Consent',
                  content: { questions: [{
                    type: :raw,
                    content: '<p class="flow-text">Geef toestemming bla bla</p>'
                  }], scores: [] }
    end
  end

  trait :with_invitation_text do
    invitation_text { 'Welcome to the u-can-act research project' }
  end

  trait :with_measurements do
    after(:create) do |protocol|
      FactoryBot.create(:measurement, protocol: protocol)
    end
  end

  trait :with_protocol_subscriptions do
    after(:create) do |protocol|
      FactoryBot.create(:protocol_subscription, protocol: protocol)
    end
  end

  trait :with_rewards do
    after(:create) do |protocol|
      FactoryBot.create(:reward, threshold: 1, reward_points: 100,  protocol: protocol)
      FactoryBot.create(:reward, threshold: 5, reward_points: 300,  protocol: protocol)
      FactoryBot.create(:reward, threshold: 7, reward_points: 500,  protocol: protocol)
    end
  end

  trait :with_student_rewards do
    after(:create) do |protocol|
      FactoryBot.create(:reward, threshold: 1, reward_points: 2,  protocol: protocol)
      FactoryBot.create(:reward, threshold: 3, reward_points: 3,  protocol: protocol)
    end
  end
end
