# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class QuestionnaireController < JwtApiController
        include QuestionnaireCreateOrUpdateHelper
        include AdminHelper
        before_action :check_admin_authenticated, only: %i[create update]
        before_action :set_questionnaire, only: %i[show update]

        def index
          render json: Questionnaire.all, each_serializer: QuestionnaireShortSerializer
        end

        def show
          respond_to do |format|
            format.csv do
              export_questionnaire
            end
            format.any do
              headers['Content-Type'] = 'application/json; charset=utf-8'
              render json: @questionnaire, serializer: Api::QuestionnaireSerializer
            end
          end
        end

        def create
          create_questionnaire
        end

        def update
          update_questionnaire(@questionnaire)
        end

        private

        def export_questionnaire
          filename = idify(@questionnaire.key)
          file_headers!(filename)
          streaming_headers!
          response.status = 200
          self.response_body = QuestionnaireExporter.export_lines(@questionnaire.name)
        end

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
