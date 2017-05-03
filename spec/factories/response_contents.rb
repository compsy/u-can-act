# frozen_string_literal: true

FactoryGirl.define do
  factory :response_content do
    content('v1' => 'slecht', 'v2' => %w[brood pizza], 'v3' => 23.0)
  end
end
