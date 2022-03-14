# frozen_string_literal: true

module Api
  class QuestionnaireSerializer < ActiveModel::Serializer
    type 'questionnaires'
    attributes :title,
               :key,
               :name,
               :content,
               :response_count

    def response_count
      object.responses.count
    end
  end
end
