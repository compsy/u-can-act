# frozen_string_literal: true

class ProofOfParticipationExporter < ObjectExporter
  class << self
    def klass
      ProtocolSubscription
    end

    def default_fields
      %w[state]
    end

    def formatted_fields
      %w[person_id first_name last_name protocol_id protocol_name number_completed start_date end_date]
    end

    # rubocop:disable Metrics/AbcSize
    def format_fields(protocol_subscription)
      vals = {}
      vals['person_id'] = protocol_subscription.person.external_identifier
      vals['first_name'] = protocol_subscription.person.first_name
      vals['last_name'] = protocol_subscription.person.last_name
      vals['protocol_id'] = protocol_subscription.protocol.id
      vals['protocol_name'] = protocol_subscription.protocol.name
      vals['number_completed'] = protocol_subscription.responses.completed.count
      vals['start_date'] = format_datetime(protocol_subscription.start_date)
      vals['end_date'] = format_datetime(protocol_subscription.end_date)
      vals
    end
    # rubocop:enable Metrics/AbcSize

    def to_be_skipped?(protocol_subscription)
      protocol_subscription.person.mentor? || Exporters.test_phone_number?(protocol_subscription.person.mobile_phone)
    end
  end
end
