# frozen_string_literal: true

FactoryBot.define do
  factory :protocol_transfer do
    from factory: :person
    to factory: :person
    protocol_subscription
  end
end
