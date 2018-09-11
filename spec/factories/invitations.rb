# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    invitation_set
    invited_state { Invitation::NOT_SENT_STATE }
  end

  factory :sms_invitation, parent: :invitation, class: 'SmsInvitation' do
    type { 'SmsInvitation' }
  end

  factory :email_invitation, parent: :invitation, class: 'EmailInvitation' do
    type { 'EmailInvitation' }
  end
end
