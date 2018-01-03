# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      before_action :verify_current_user

      def check_access_allowed(protocol_subscription)
        current_user_has_access = protocol_subscription.person == @current_user
        current_mentor_has_access = protocol_subscription.person.mentor == @current_user
        current_mentor_has_access || current_user_has_access
      end

      private

      def verify_current_user
        response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
        @response = Response.find_by_id(response_id)
        if @response.nil?
          render(status: 401, json: 'This api is only accessible after completing a questionnaire')
          return
        end
        @current_user = @response.protocol_subscription.person
      end
    end
  end
end
