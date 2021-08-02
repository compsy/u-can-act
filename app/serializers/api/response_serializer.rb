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
                  invitation_texts]

    # It doesn't work with has_one because for some reason it passes the wrong object
    def questionnaire
      QuestionnaireShortSerializer.new(object.measurement.questionnaire)
    end
  end
end
