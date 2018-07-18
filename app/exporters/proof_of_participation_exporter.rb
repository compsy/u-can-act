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
      %w[first_name last_name number_completed start_date end_date]
    end

    def format_fields(protocol_subscription)
      vals = {}
      vals['first_name'] = protocol_subscription.person.first_name
      vals['last_name'] = protocol_subscription.person.last_name
      vals['number_completed'] = protocol_subscription.responses.completed.count
      vals['start_date'] = format_datetime(protocol_subscription.end_date)
      vals['end_date'] = format_datetime(protocol_subscription.end_date)
      vals
    end

    def to_be_skipped?(protocol_subscription)
      Exporters.test_phone_number?(protocol_subscription.person.mobile_phone)
    end
  end
end
