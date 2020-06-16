# frozen_string_literal: true

class InvitationSet < ApplicationRecord
  belongs_to :person
  validates :person_id, presence: true
  has_many :invitations, dependent: :destroy
  has_many :responses, dependent: :nullify # no dependent destroy relation needed,
  # responses are already destroyed through person->protocol_subscriptions->responses
  has_many :invitation_tokens, dependent: :destroy

  def invitation_url(plain_text_token, full = true)
    raise 'Cannot generate invitation_url for historical invitation tokens!' if plain_text_token.blank?

    concatenated_token = "#{person.external_identifier}#{plain_text_token}"
    return "?q=#{concatenated_token}" unless full

    "#{ENV['HOST_URL']}/?q=#{concatenated_token}"
  end

  def reminder_delay
    delay = responses.map do |response|
      response.measurement.reminder_delay
    end.compact.min
    delay || Measurement::DEFAULT_REMINDER_DELAY
  end

  def sorted_responses
    responses.sort_by do |response|
      # Sort by descending priority first, and then ascending open_from.
      # Show items with priority nil after any items with non-nil priority.
      [-1 * (response.measurement.priority.presence || (Measurement::MIN_PRIORITY - 1)), response.open_from]
    end
  end
end
