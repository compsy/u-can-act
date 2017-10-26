# frozen_string_literal: true

FactoryGirl.define do
  sequence(:mobile_phone) { |n| "06#{format('%08d', n)}" }
  factory :person do
    role
    gender Person::MALE
    mobile_phone
    first_name 'Jane'
    last_name 'Doe'

    trait :with_random_name do
      sequence(:first_name, 'a') { |n| 'Janine' + n }
      sequence(:last_name, 'a') { |n| 'Douval' + n }
    end

    trait :with_protocol_subscriptions do
      after(:create) do |person|
        FactoryGirl.create(:protocol_subscription, person: person)
      end
    end
  end

  factory :mentor, class: 'Person', parent: :person do
    role { FactoryGirl.create(:role, group: Person::MENTOR, title: 'mentor Title') }
  end

  factory :student, class: 'Person', parent: :person do
    role { FactoryGirl.create(:role, group: Person::STUDENT, title: 'student Title') }
  end
end
