# frozen_string_literal: true

FactoryBot.define do
  factory :invitation_token do
    initialize_with { new(attributes) } # This makes it so that after_initialize blocks in the model are called.
    invitation_set
  end
end
