# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class JwtApiController < ApiController
        include ::IsJwtAuthenticated
        before_action :set_person

        private

        def set_person
          # Debugging
          # token = request.headers['Authorization'].split.last
          # Rails.logger.warn Knock::AuthToken.new(token: token)
          # Rails.logger.warn current_auth_user.person.inspect
          return if current_user.present?

          result = { result: current_auth_user.to_json }
          render(status: :not_found, json: result)
        end
      end
    end
  end
end
