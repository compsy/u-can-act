# frozen_string_literal: true

module Api
  class QuestionnaireSerializer < ActiveModel::Serializer
    type 'questionnaires'
    attributes :title,
               :key,
               :name,
               :content
  end
end
