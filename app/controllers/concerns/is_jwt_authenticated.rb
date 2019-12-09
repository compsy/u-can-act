# frozen_string_literal: true

module Concerns
  module IsJwtAuthenticated
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_auth_user # This calls AuthUser#from_token_payload
      rescue_from Knock.not_found_exception_class, JWT::DecodeError, JWT::EncodeError, with: :render_bad_request

      def current_auth_user
        @current_auth_user ||= Knock::AuthToken.new(token: token).entity_for(AuthUser)
      end

      def token
        params[:token] || token_from_request_headers
      end

      def token_from_request_headers
        if request.headers['Authorization'].present?
          request.headers['Authorization'].split.last
        end
      end

      def render_bad_request(e)
        render json: { error: e.message }, status: :bad_request
      end
    end
  end
end
