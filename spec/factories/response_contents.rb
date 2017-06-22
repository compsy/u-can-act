# frozen_string_literal: true

FactoryGirl.define do
  factory :response_content do
    content('v1' => 'slecht', 'v2_brood' => 'true', 'v3' => '23.0')
  end
end
