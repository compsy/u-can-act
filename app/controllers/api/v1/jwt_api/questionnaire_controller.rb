# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class QuestionnaireController < JwtApiController
        before_action :check_admin_authenticated, only: %i[create]
        before_action :check_distributions_enabled, only: %i[distribution]
        before_action :set_questionnaire, only: %i[show distribution]
        before_action :set_distribution_and_check_min_responses, only: %i[distribution]

        def show
          # TODO: Add different formats
          render json: @questionnaire, serializer: Api::QuestionnaireSerializer
        end

        def distribution
          render json: @distribution
        end

        def create
          questionnaire = Questionnaire.new(questionnaire_params)
          if questionnaire.save
            head 201
          else
            result = { result: questionnaire.errors }
            render(status: :bad_request, json: result)
          end
        end

        private

        def check_admin_authenticated
          return if current_auth_user.access_level == AuthUser::ADMIN_ACCESS_LEVEL

          result = { result: 'User is not an admin' }

          render(status: :forbidden, json: result)
        end

        def check_distributions_enabled
          return if Rails.application.config.settings.feature_toggles.allow_distribution_export

          render(status: :forbidden, json: 'Allow distribution export feature flag not enabled.')
        end

        def set_questionnaire
          @questionnaire = Questionnaire.find_by(key: params[:key])
          return if @questionnaire.present?

          render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
        end

        def set_distribution_and_check_min_responses
          @distribution = RedisService.get("distribution_#{@questionnaire.key}") || '{}'

          distribution = JSON.parse(@distribution)
          return if distribution.present? &&
                    distribution['total'].present? &&
                    distribution['total'] >= Rails.application.config.settings.distribution_export_min_responses

          render(status: :forbidden, json: 'Number of completed responses for this questionnaire is below the minimum')
        end

        def questionnaire_params
          load_params = params.require(:questionnaire).permit(:name, :key, :title)

          # Whitelist the array
          # see https://github.com/rails/rails/issues/9454
          load_params[:content] = params[:questionnaire][:content] if params[:questionnaire][:content]
          load_params.permit!
        end
      end
    end
  end
end
