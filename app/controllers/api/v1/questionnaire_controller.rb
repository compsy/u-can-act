# frozen_string_literal: true

module Api
  module V1
    class QuestionnaireController < ApiController
      before_action :set_questionnaire, only: %i[show]
      before_action :check_questionnaire_content, only: %i[create]
      before_action :set_questionnaire_content, only: %i[create]

      def show
        render json: @questionnaire, serializer: Api::QuestionnaireSerializer
      end

      def create
        @raw_questionnaire_content = @raw_questionnaire_content.map(&:with_indifferent_access)
        @content = QuestionnaireGenerator.new.generate_questionnaire(
          response_id: nil,
          content: @raw_questionnaire_content,
          title: 'Test questionnaire',
          submit_text: 'Opslaan',
          action: '/api/v1/questionnaire/from_json',
          unsubscribe_url: nil
        )

        render 'questionnaire/show'
      end

      private

      def check_questionnaire_content
        return unless params.blank? || params[:content].blank?

        render(status: :bad_request, json: 'Please supply a json file in the content field.')
      end

      def set_questionnaire_content
        @raw_questionnaire_content = JSON.parse(params[:content])
        if @raw_questionnaire_content.blank? || !(@raw_questionnaire_content.is_a? Array)
          render status: :bad_request, json: { error: 'At least one question should be provided, in an array' }
          return
        end
      rescue JSON::ParserError => e
        render status: :bad_request, json: { error: e.message }
      end

      def set_questionnaire
        @questionnaire = Questionnaire.find_by(key: params[:key])
        return if @questionnaire.present?

        render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
      end
    end
  end
end
