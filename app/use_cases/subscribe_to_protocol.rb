# frozen_string_literal: true

class SubscribeToProtocol < AsyncActiveInteraction
  string :protocol_name, default: nil
  object :protocol, default: nil
  object :person
  object :mentor, default: nil, class: :person
  string :external_identifier, default: nil
  string :invitation_text_nl, default: nil
  string :invitation_text_en, default: nil
  boolean :open_from_day_uses_start_date_offset, default: false

  # Watch out! IF you set a start date here (e.g. = Time.now.in_time_zone) it
  # will set it once, and reuse THAT time everytime. I.e., it will not update
  # the time when time passes.
  time :start_date, default: nil
  time :end_date, default: nil

  boolean :only_if_not_subscribed, default: false

  # Function to start a protocol subscription for a person
  #
  # Params:
  # - protocol_name: the name of the protocol to start (optional)
  # - protocol: the protocol to subscribe the person to (optional)
  # - person: the person to start the protocol for
  # - start_date: the date when the subscription should start
  def execute
    the_protocol = find_protocol
    the_start_date = find_start_date
    Rails.logger.warn("Protocol #{the_protocol.id} does not have any measurements") if the_protocol.measurements.blank?

    create_or_find_protocol_subscription(the_protocol, the_start_date)
  end

  def create_or_find_protocol_subscription(the_protocol, the_start_date)
    prot_sub = nil
    prot_sub = person.protocol_subscriptions.active.where(protocol_id: the_protocol.id).first if only_if_not_subscribed
    prot_sub || ProtocolSubscription.create!(
      protocol: the_protocol,
      person: person,
      filling_out_for: mentor,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: the_start_date,
      end_date: end_date,
      external_identifier: external_identifier,
      invitation_text_nl: invitation_text_nl,
      invitation_text_en: invitation_text_en,
      open_from_day_uses_start_date_offset: open_from_day_uses_start_date_offset
    )
  end

  def find_start_date
    # Active interaction weirdness. For some reason if we do not first copy
    # start_date into a different variable, it is nil and overridden by the if
    # statement. When we first copy it to a different variable it does work.
    the_start_date = start_date
    the_start_date || Time.now.in_time_zone
  end

  def find_protocol
    return Protocol.find_by(id: protocol.id) if protocol&.id.present?

    the_protocol = Protocol.find_by(name: protocol_name)
    return the_protocol if the_protocol.present?

    raise 'Protocol not found'
  end
end
