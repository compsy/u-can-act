# frozen_string_literal: true

class ProtocolTransferExporter < ObjectExporter
  class << self
    def klass
      ProtocolTransfer
    end

    def default_fields
      %w[protocol_subscription_id]
    end

    def formatted_fields
      %w[protocol_transfer_id from_id to_id created_at updated_at]
    end

    def format_fields(protocol_transfer)
      {
        'protocol_transfer_id' => protocol_transfer.id,
        'from_id' => calculate_hash(protocol_transfer.from_id),
        'to_id' => calculate_hash(protocol_transfer.to_id),
        'created_at' => format_datetime(protocol_transfer.created_at),
        'updated_at' => format_datetime(protocol_transfer.updated_at)
      }
    end

    def to_be_skipped?(protocol_transfer)
      TEST_PHONE_NUMBERS.include?(protocol_transfer.protocol_subscription.person.mobile_phone)
    end
  end
end
