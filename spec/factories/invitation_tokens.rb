# frozen_string_literal: true

FactoryBot.define do
  factory :invitation_token do
    invitation_set
    # TODO: the prop below is not needed if initialized?
    token '1234'
  end
end
