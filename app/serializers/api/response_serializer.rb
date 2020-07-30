# frozen_string_literal: true

module Api
  class ResponseSerializer < ActiveModel::Serializer
    type 'responses'
    attributes %i[uuid open_from expires_at opened_at completed_at values external_identifier questionnaire]

    # It doesn't work with has_one because for some reason it passes the wrong object
    def questionnaire
      QuestionnaireShortSerializer.new(object.measurement.questionnaire)
    end

    def external_identifier
      object.protocol_subscription.external_identifier # can be blank
    end
  end
end
