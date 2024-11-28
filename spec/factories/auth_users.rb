# frozen_string_literal: true

FactoryBot.define do
  sequence(:auth0_id_string) { |n| "id_#{format('%<number>010d', number: n)}" }
  factory :auth_user do
    auth0_id_string
    password_digest { 'thepasswordwhicisrandom' }
    access_level { AuthUser::USER_ACCESS_LEVEL }
    person { nil }

    trait :with_person do
      person
    end
    trait :admin do
      access_level { AuthUser::ADMIN_ACCESS_LEVEL }
    end
  end
end
