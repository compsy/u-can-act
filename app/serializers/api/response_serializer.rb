<<<<<<< HEAD
# frozen_string_literal: true

module Api
  class ResponseSerializer < ActiveModel::Serializer
    attributes :uuid
    has_one :questionnaire do
      QuestionnaireShortSerializer.new(object.measurement.questionnaire)
    end
  end
end
