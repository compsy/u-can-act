# frozen_string_literal: true

module Api
  module V1
    class QuestionnaireController < ApiController
      before_action :set_questionnaire, only: %i[show]

      def show
        render json: @questionnaire, serializer: Api::QuestionnaireSerializer
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
