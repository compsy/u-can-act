# frozen_string_literal: true

module Api
  class PersonalizedQuestionnaireSerializer < ActiveModel::Serializer
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
      @questionnaire = QuestionnaireGenerator.generate_json_questionnaire(
        object.id,
        questionnaire.content,
        questionnaire.name
      )
    end
  end
end
