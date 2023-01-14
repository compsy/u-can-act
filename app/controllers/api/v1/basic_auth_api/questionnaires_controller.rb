# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class QuestionnairesController < BasicAuthApiController
        include QuestionnaireCreateOrUpdateHelper
        before_action :set_questionnaire, only: %i[show]

        def show
          render json: @questionnaire, serializer: Api::QuestionnaireSerializer
        end

        def create
          create_questionnaire
        end

        private

        def set_questionnaire
          @questionnaire = Questionnaire.find_by(key: params[:id])
          return if @questionnaire.present?

          render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
        end
      end
    end
  end
end
