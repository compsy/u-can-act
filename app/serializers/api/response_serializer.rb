# frozen_string_literal: true

module Api
  class ResponseSerializer < ActiveModel::Serializer
    type 'responses'
    attributes %i[uuid open_from expires_at opened_at completed_at values external_identifier]
    has_one :questionnaire do
      QuestionnaireShortSerializer.new(object.measurement.questionnaire)
    end

    def external_identifier
      object.protocol_subscription.external_identifier # can be blank
    end
  end
end
