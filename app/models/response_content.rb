# frozen_string_literal: true

class ResponseContent
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: Hash, default: {}
  field :scores, type: Hash, default: {}

  class << self
    def create_with_scores!(content:, response:)
      questionnaire = response.measurement.questionnaire.content
      create_aux!(content: content, questionnaire: questionnaire)
    end

    def create_informed_consent_with_scores!(content:, protocol_subscription:)
      questionnaire = protocol_subscription.protocol.informed_consent_questionnaire.content
      create_aux!(content: content, questionnaire: questionnaire)
    end

    private

    def create_aux!(content:, questionnaire:)
      scores = CalculateScores.run!(content: content, questionnaire: questionnaire)
      create!(content: content, scores: scores)
    end
  end
end
