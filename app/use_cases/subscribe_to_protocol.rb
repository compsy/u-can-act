# frozen_string_literal: true

class SubscribeToProtocol < ActiveInteraction::Base
  string :protocol_name, default: nil
  object :protocol, default: nil
  object :person

  # Watch out! IF you set a start date here (e.g. = Time.now.in_time_zone) it
  # will set it once, and reuse THAT time everytime. I.e., it will not update
  # the time when time passes.
  time :start_date, default: nil

  # Function to start a protocol subscription for a person
  #
  # Params:
  # - protocol_name: the name of the protocol to start (optional)
  # - protocol: the protocol to subscribe the person to (optional)
  # - person: the person to start the protocol for
  # - start_date: the date when the subscription should start
  def execute
    protocol = find_protocol
    the_start_date = find_start_date
    Rails.logger.warn("Protocol #{protocol.id} does not have any measurements")

    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: the_start_date
    )
    prot_sub
  end

  def find_start_date
    # Active interaction weirdness. For somereason if we do not first copy
    # start_date into a different variable, it is nil and overridden by the if
    # statement. When we first copy it to a different variable it does work.
    the_start_date = start_date
    the_start_date || Time.now.in_time_zone
  end

  def find_protocol
    return protocol if protocol.present?

    protocol = Protocol.find_by_name(protocol_name)
    return protocol if protocol.present?

    raise 'Protocol not found'
  end
end
