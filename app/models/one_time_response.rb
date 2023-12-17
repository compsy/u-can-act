# frozen_string_literal: true

class OneTimeResponse < ApplicationRecord
  belongs_to :protocol
  validates :token, presence: true, uniqueness: true
  validates :restricted, inclusion: [true, false]

  TOKEN_LENGTH = 8

  after_initialize do |one_time_response|
    next if one_time_response.token.present?

    loop do
      one_time_response.token = RandomStringGenerator.generate_alpha_numeric(OneTimeResponse::TOKEN_LENGTH)
      break if OneTimeResponse.where(token: one_time_response.token).count.zero?
    end
  end

  def redirect_url(person)
    create_response(person) if restricted?
    responses = person.all_my_open_one_time_responses.select do |elem|
      elem.protocol_subscription.protocol.id == protocol.id
    end
    return nil if restricted? && responses.blank?

    invitation_set = InvitationSet.create!(person_id: person.id,
                                           responses: responses)

    invitation_token = invitation_set.invitation_tokens.create!
    invitation_set.invitation_url(invitation_token.token_plain, false)
  end

  def subscribe_person(person, mentor = nil)
    # For restricted OTRs, the person already needs to be subscribed.
    return if restricted?

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

  private

  def create_response(person)
    protocol_subscriptions = ProtocolSubscription.active.where(person: person, protocol: protocol)
    # If we are not subscribed, don't create a response.
    return if protocol_subscriptions.blank?

    responses = Response.where(protocol_subscription: protocol_subscriptions).opened_and_not_expired
    # If we already have an open response, don't create a new one.
    return if responses.present?

    Response.create(protocol_subscription: protocol_subscriptions.first,
                    measurement: protocol.measurements.first,
                    open_from: 1.second.ago)
  end
end
