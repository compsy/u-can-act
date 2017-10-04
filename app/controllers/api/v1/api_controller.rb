# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      before_action :verify_current_user

      def check_access_allowed(protocol_subscription)
        allowed = protocol_subscription.person == @current_user ||
                  protocol_subscription.filling_out_for == @current_user
        allowed
      end

      private

      def verify_current_user
        response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
        @response = Response.find_by_id(response_id)
        if @response.nil?
          render(status: 401, json: 'This api is only accessible after compling a questionnaire')
          return
        end
        @current_user = @response.protocol_subscription.person
      end
    end
  end
end
