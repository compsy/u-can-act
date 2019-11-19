# frozen_string_literal: true

FactoryBot.define do
  sequence(:push_subscription_name) { |n| "push-subscription-#{n}" }
  factory :push_subscription do
    name { generate(:push_subscription_name) }
    url { 'http://web:2000/api/v1/data/create_raw' }
    add_attribute(:method) { 'POST' }
    protocol
  end
end
