# frozen_string_literal: true

module Api
  class QuestionnaireShortSerializer < ActiveModel::Serializer
    attributes :key, :title
  end
end
