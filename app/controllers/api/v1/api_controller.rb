# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Knock::Authenticable
      skip_before_action :verify_authenticity_token

      private 

      def unauthorized_entity(entity_name)
        render json: { error: "#{entity_name} Unauthorized request" }, status: :unauthorized
      end

      # Called from the middleware!
      def raise_bad_request
        render plain: "Error while parsing json parameters: #{request.env['RAW_POST_DATA']}", status: 400
      end

      def check_access_allowed(protocol_subscription)
        current_user_has_access = protocol_subscription.person == current_user
        current_mentor_has_access = protocol_subscription.person.mentor == current_user
        current_mentor_has_access || current_user_has_access
      end
    end
  end
end
