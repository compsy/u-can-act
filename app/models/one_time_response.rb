# frozen_string_literal: true

class OneTimeResponse < ApplicationRecord
  belongs_to :protocol
  validates :protocol_id, presence: true
  validates :token, presence: true, uniqueness: true

  TOKEN_LENGTH = 8

  after_initialize do |one_time_response|
    next if one_time_response.token.present?

    loop do
      one_time_response.token = RandomStringGenerator.generate_alpha_numeric(OneTimeResponse::TOKEN_LENGTH)
      break if OneTimeResponse.where(token: one_time_response.token).count.zero?
    end
  end

  def redirect_url(person)
    responses = person.all_my_open_one_time_responses.select do |elem|
      elem.protocol_subscription.protocol.id == protocol.id
    end
    invitation_set = InvitationSet.create!(person_id: person.id,
                                           responses: responses)

    invitation_token = invitation_set.invitation_tokens.create!
    invitation_set.invitation_url(invitation_token.token_plain, false)
  end

  def subscribe_person(person, mentor = nil)
    protocol_subscription = SubscribeToProtocol.run!(
      protocol: protocol,
      mentor: mentor,
      person: person,
      only_if_not_subscribed: true
    )

    RescheduleResponses.run!(
      protocol_subscription: protocol_subscription,
      future: 10.minutes.ago
    )
  end
end
