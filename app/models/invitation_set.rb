# frozen_string_literal: true

class InvitationSet < ApplicationRecord
  belongs_to :person
  validates :person_id, presence: true
  has_many :invitations, dependent: :destroy
  has_many :responses # no dependent destroy relation needed,
                      # responses are already destroyed through person->protocol_subscriptions->responses
  has_many :invitation_tokens, dependent: :destroy
end
