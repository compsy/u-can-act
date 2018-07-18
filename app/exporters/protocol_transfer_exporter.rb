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
        'from_id' => protocol_transfer.from.external_identifier,
        'to_id' => protocol_transfer.to.external_identifier,
        'created_at' => format_datetime(protocol_transfer.created_at),
        'updated_at' => format_datetime(protocol_transfer.updated_at)
      }
    end

    def to_be_skipped?(protocol_transfer)
      Exporters.test_phone_number?(protocol_transfer.protocol_subscription.person.mobile_phone)
    end
  end
end
