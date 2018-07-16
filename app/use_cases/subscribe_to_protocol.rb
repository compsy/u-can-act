# frozen_string_literal: true

class SubscribeToProtocol < ActiveInteraction::Base
  string :protocol_name
  object :person
  time :start_date, default: Time.zone.now

  # Function to start a protocol subscription for a person
  #
  # Params:
  # - Protocol_name: the name of the protocol to start
  # - person: the person to start the protocol for
  # - start_date: the date when the subscription should start
  def execute
    protocol = Protocol.find_by_name(protocol_name)
    raise 'Protocol not found' unless protocol.present?
    raise 'Person is nil' unless person.present?

    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: start_date
    )
    prot_sub
  end
end
