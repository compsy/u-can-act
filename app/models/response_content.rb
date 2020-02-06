# frozen_string_literal: true

class ResponseContent
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: Hash

  class << self
    def create_with_scores!(content:, response:)
      questionnaire = response.measurement.questionnaire.content
      enriched_content = EnrichContent.run!(content: content, questionnaire: questionnaire)
      create!(content: enriched_content)
    end
  end
end
