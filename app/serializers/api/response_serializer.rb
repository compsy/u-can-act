# frozen_string_literal: true

module Api
  class ResponseSerializer < ActiveModel::Serializer
    type 'responses'

    # `external_identifier` is the external identifier of just this response alone.
    # `external_identifiers` is the array of external identifiers of this response
    # and possible clones of this response (responses from the same protocol but different
    # protocol subscription but from the same person and scheduled at around the same time).
    attributes %i[uuid open_from expires_at opened_at completed_at
                  values external_identifier questionnaire external_identifiers
                  invitation_texts protocol_completion measurement_id protocol_subscription_id]

    # It doesn't work with has_one because for some reason it passes the wrong object
    def questionnaire
      QuestionnaireShortSerializer.new(object.measurement.questionnaire)
    end

    # Only calculate and send it when we specifically ask for it (e.g., for push subscriptions).
    def protocol_completion
      return protocol_completion_without_future if instance_options[:with_protocol_completion]

      []
    end

    private

    def protocol_completion_without_future
      object.protocol_subscription.protocol_completion.reject { |entry| entry[:future].present? }
    end
  end
end
