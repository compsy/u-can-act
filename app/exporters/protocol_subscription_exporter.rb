# frozen_string_literal: true

class ProtocolSubscriptionExporter < ObjectExporter
  class << self
    def klass
      ProtocolSubscription
    end

    def default_fields
      %w[state]
    end

    def formatted_fields
      %w[protocol_subscription_id person_id created_at updated_at start_date end_date
         protocol informed_consent_content informed_consent_given_at filling_out_for_person_id]
    end

    def format_fields(protocol_subscription)
      vals = {
        'protocol_subscription_id' => protocol_subscription.id,
        'person_id' => protocol_subscription.person.external_identifier,
        'created_at' => format_datetime(protocol_subscription.created_at),
        'updated_at' => format_datetime(protocol_subscription.updated_at),
        'start_date' => format_datetime(protocol_subscription.start_date)
      }
      add_more_fields(vals, protocol_subscription)
    end

    def to_be_skipped?(protocol_subscription)
      Exporters.test_phone_number?(protocol_subscription.person.mobile_phone)
    end

    private

    def add_more_fields(vals, protocol_subscription)
      vals['end_date'] = format_datetime(protocol_subscription.end_date)
      vals['protocol'] = protocol_subscription.protocol.name
      vals['informed_consent_given_at'] = format_datetime(protocol_subscription.informed_consent_given_at)
      vals['filling_out_for_person_id'] = protocol_subscription.filling_out_for.external_identifier
      ic_content = ''
      if protocol_subscription.informed_consent_given_at && protocol_subscription.informed_consent_content
        ic_content = protocol_subscription.informed_consent_values.to_json
      end
      vals['informed_consent_content'] = ic_content
      vals
    end
  end
end
