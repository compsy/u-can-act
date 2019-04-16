# frozen_string_literal: true

module Api
  module V1
    class QuestionnaireController < ApiController
      before_action :set_questionnaire, only: %i[show]

      def show
        render json: @questionnaire, serializer: Api::QuestionnaireSerializer
      end

      def create
        raw_questionnaire_content = JSON.parse(params[:content])
        raw_questionnaire_content = raw_questionnaire_content.map(&:with_indifferent_access)
        @content = QuestionnaireGenerator.new.generate_questionnaire(
          response_id: nil,
          content: raw_questionnaire_content,
          title: 'Test questionnaire',
          submit_text: 'Opslaan',
          action: '/api/v1/questionnaire/from_json',
          unsubscribe_url: nil
        )

        render 'questionnaire/show'
      rescue JSON::ParserError => e
        render status: 400, json: { error: e.message }
      end

      private

      def set_questionnaire
        @questionnaire = Questionnaire.find_by_key(params[:key])
        return if @questionnaire.present?

        render(status: 404, json: 'Vragenlijst met die key niet gevonden')
      end
    end
  end
end
