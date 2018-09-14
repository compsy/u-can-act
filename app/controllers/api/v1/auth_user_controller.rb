# frozen_string_literal: true

module Api
  module V1
    class AuthUserController < ApiController
      include ::Concerns::IsJwtAuthenticated
      before_action :set_person, only: %i[create]

      def create
        render json: current_auth_user, serializer: Api::AuthUserSerializer
      end

      def set_person
        return if current_auth_user&.person.present?
        result = { result: current_auth_user.to_json }
        render(status: 404, json: result)
      end
    end
  end
end
