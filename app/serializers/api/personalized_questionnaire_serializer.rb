# frozen_string_literal: true

module Api
  class PersonalizedQuestionnaireSerializer < ActiveModel::Serializer
    type 'responses'
    attributes :uuid
    attributes :questionnaire_title
    attributes :questionnaire_content

    def questionnaire_content
      questionnaire[:content]
    end

    def questionnaire_title
      questionnaire[:title]
    end

    private

    def questionnaire
      return @questionnaire if @questionnaire.present?

      questionnaire = object.measurement.questionnaire
      generator = QuestionnaireGenerator.new
      @questionnaire = generator.generate_hash_questionnaire(
        object.id,
        questionnaire.content,
        questionnaire.title
      )
    end
  end
end
