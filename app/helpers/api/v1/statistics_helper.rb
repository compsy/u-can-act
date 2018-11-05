# frozen_string_literal: true

module Api
  module V1
    module StatisticsHelper
      def number_of_informed_consents_given(protocol_names)
        # If this method is used to count people then it is assumed that a person is asked
        # for informed consent in at most one of her protocols.
        return 0 if protocol_names.blank? # In case the `protocol_names` setting was nil

        protocol_ids = protocol_names.map do |protocol_name|
          Protocol.find_by_name(protocol_name)&.id
        end.compact
        return 0 if protocol_ids.blank?

        ProtocolSubscription.where('informed_consent_given_at IS NOT NULL').where(protocol_id: protocol_ids).count
      end
    end
  end
end
