# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class QuestionnaireController < JwtApiController
        include QuestionnaireCreateHelper
        before_action :check_admin_authenticated, only: %i[create]
        before_action :set_questionnaire, only: %i[show]

        def create
          create_questionnaire
        end

        def show
          # TODO: Add different formats
          render json: @questionnaire, serializer: Api::QuestionnaireSerializer
        end

        private

        def check_admin_authenticated
          return if current_auth_user.access_level == AuthUser::ADMIN_ACCESS_LEVEL

          result = { result: 'User is not an admin' }

          render(status: :forbidden, json: result)
        end

        def set_questionnaire
          @questionnaire = Questionnaire.find_by(key: params[:key])
          return if @questionnaire.present?

          render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
        end
      end
    end
  end
end
