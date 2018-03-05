# frozen_string_literal: true

class InvitationSet < ApplicationRecord
  belongs_to :person
  validates :person_id, presence: true
  has_many :invitations, dependent: :destroy
  has_many :responses # no dependent destroy relation needed,
  # responses are already destroyed through person->protocol_subscriptions->responses
  has_many :invitation_tokens, dependent: :destroy

  def invitation_url(plain_text_token, full = true)
    raise 'Cannot generate invitation_url for historical invitation tokens!' if plain_text_token.blank?
    concatenated_token = "#{person.external_identifier}#{plain_text_token}"
    return "?q=#{concatenated_token}" unless full
    "#{ENV['HOST_URL']}?q=#{concatenated_token}"
  end
end
