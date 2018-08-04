# frozen_string_literal: true

module Api
  module V1
    class QuestionnaireController < ApiController
      before_action :authenticate_person
      before_action :set_questionnaire, only: %i[show]

      def show
        render json: @questionnaire, serializer: Api::QuestionnaireSerializer

        # TODO: Add different formats
        content = rendered_questionnaire_content(@questionnaire)
        render html: content
      end

      def create
      end

      private

      def set_questionnaire
        @questionnaire = Questionnaire.find_by_key(params[:key])
        return if @questionnaire.present?
        render(status: 404, json: 'Vragenlijst met die key niet gevonden')
      end

      def rendered_questionnaire_content
        @content = QuestionnaireGenerator.generate_questionnaire(@response.id,
                                                                 @response.measurement.questionnaire.content,
                                                                 @response.measurement.questionnaire.title,
                                                                 'Opslaan',
                                                                 '/',
                                                                 form_authenticity_token(form_options: { action: '/',
                                                                                                         method: 'post' }))
      end
    end
  end
end
