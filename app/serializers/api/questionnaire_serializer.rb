# frozen_string_literal: true

module Api
  class QuestionnaireSerializer < ActiveModel::Serializer
    attributes :title,
               :key,
               :name,
               :content
  end
end
