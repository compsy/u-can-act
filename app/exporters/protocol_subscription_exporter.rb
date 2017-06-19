# frozen_string_literal: true

require 'csv'

class ProtocolSubscriptionExporter
  extend Exporters
  class << self
    def export(&_block)
      fields = %w[state]
      headers = %w[protocol_subscription_id person_id created_at updated_at start_date protocol
                   informed_consent_given_at filling_out_for_person_id] + fields
      yield format_headers(headers)
      silence_logger do
        ProtocolSubscription.find_each do |protocol_subscription|
          next if TEST_PHONE_NUMBERS.include?(protocol_subscription.person.mobile_phone)
          vals = header_properties(protocol_subscription)
          fields.each do |field|
            vals[field] = protocol_subscription.send(field.to_sym)
          end
          yield format_hash(headers, vals)
        end
      end
    end

    def export_lines
      Enumerator.new do |enum|
        export do |line|
          enum << line + "\n"
        end
      end
    end

    private

    def header_properties(protocol_subscription)
      vals = {
        'protocol_subscription_id' => protocol_subscription.id,
        'person_id' => calculate_hash(protocol_subscription.person.id),
        'created_at' => format_datetime(protocol_subscription.created_at),
        'updated_at' => format_datetime(protocol_subscription.updated_at),
        'start_date' => format_datetime(protocol_subscription.start_date)
      }
      vals = add_more_fields(vals)
      vals
    end

    def add_more_fields(vals)
      vals['protocol'] = protocol_subscription.protocol.name
      vals['informed_consent_given_at'] = format_datetime(protocol_subscription.informed_consent_given_at)
      vals['filling_out_for_person_id'] = calculate_hash(protocol_subscription.filling_out_for_id)
      vals
    end
  end
end
