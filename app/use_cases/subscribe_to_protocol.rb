# frozen_string_literal: true

class SubscribeToProtocol < ActiveInteraction::Base
  string :protocol_name
  object :person
  # Watch out! IF you set a start date here (e.g. = Time.now.in_time_zone) it
  # will set it once, and reuse THAT time everytime. I.e., it will not update
  # the time when time passes.
  time :start_date, default: nil

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

    start_date = Time.now.in_time_zone if start_date.blank?
    Rails.logger.info("Starting a protocol subscription at #{start_date}. It is now #{Time.zone.now}")

    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: start_date
    )
    prot_sub
  end
end
