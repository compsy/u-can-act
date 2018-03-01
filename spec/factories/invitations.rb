# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    invitation_set
    invited_state Invitation::NOT_SENT_STATE
    type 'SmsInvitation'

    trait :email do
      type 'EmailInvitation'
    end
  end
end
