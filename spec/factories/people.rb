# frozen_string_literal: true

FactoryBot.define do
  sequence(:mobile_phone) { |n| "06#{format('%08d', n)}" }
  factory :person do
    initialize_with { new(attributes) } # This makes it so that after_initialize blocks in the model are called.
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
        FactoryBot.create(:protocol_subscription, person: person)
      end
    end
  end

  trait :with_iban do
    iban 'NL91ABNA0417164300'
  end

  trait :with_test_phone_number do
    mobile_phone ENV['TEST_PHONE_NUMBERS'].split(',').first
  end

  factory :mentor, class: 'Person', parent: :person do
    email 'mentor@mentor.com'
    role { FactoryBot.create(:role, group: Person::MENTOR, title: 'mentor Title') }
  end

  factory :student, class: 'Person', parent: :person do
    role { FactoryBot.create(:role, group: Person::STUDENT, title: 'student Title') }
  end
end
