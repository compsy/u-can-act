# frozen_string_literal: true

module Api
  class ResponseSerializer < ActiveModel::Serializer
    attributes :id, :questionnaire

    def questionnaire
      {
        key: object.measurement.questionnaire.key,
        name: object.measurement.questionnaire.name
      }
    end
  end
end
