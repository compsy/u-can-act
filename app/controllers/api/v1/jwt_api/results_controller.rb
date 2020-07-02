# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class ResultsController < JwtApiController
        before_action :check_distributions_enabled, only: %i[distribution]
        before_action :set_questionnaire, only: %i[distribution]
        before_action :set_distribution_and_check_min_responses, only: %i[distribution]

        def distribution
          render json: @distribution
        end

        private

        def check_distributions_enabled
          return if Rails.application.config.settings.feature_toggles.allow_distribution_export

          render(status: :forbidden, json: 'Allow distribution export feature flag not enabled')
        end

        def set_questionnaire
          @questionnaire = Questionnaire.find_by(key: params[:questionnaire_key])
          return if @questionnaire.present?

          render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
        end

        def set_distribution_and_check_min_responses
          @distribution = RedisService.get("distribution_#{@questionnaire.key}") || '{}'

          distribution = JSON.parse(@distribution)
          return if distribution.present? &&
                    distribution['total'].present? &&
                    distribution['total'] >= Rails.application.config.settings.distribution_export_min_responses

          render(json: { total: 0, error: 'Not enough filled out questionnaires to display results' })
        end
      end
    end
  end
end
