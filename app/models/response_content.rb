# frozen_string_literal: true

class ResponseContent
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: Hash, default: {}
  field :scores, type: Hash, default: {}

  class << self
    def create_with_scores!(content:, response:)
      questionnaire = response.measurement.questionnaire.content
      scores = CalculateScores.run!(content: content, questionnaire: questionnaire)
      create!(content: content, scores: scores)
    end
  end
end
