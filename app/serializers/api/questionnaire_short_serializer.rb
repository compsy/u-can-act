# frozen_string_literal: true

module Api
  class QuestionnaireShortSerializer < ActiveModel::Serializer
    type 'questionnaires'
    attributes :key, :title
  end
end
