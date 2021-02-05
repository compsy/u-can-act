# frozen_string_literal: true

FactoryBot.define do
  factory :protocol_subscription do
    initialize_with { new(attributes) } # This makes it so that after_initialize blocks in the model are called.
    person
    protocol
    state { ProtocolSubscription::ACTIVE_STATE }
    start_date { 2.weeks.ago }

    trait :mentor do
      filling_out_for { create(:person) }
    end

    trait :canceled do
      state { ProtocolSubscription::CANCELED_STATE }
    end
  end
end
