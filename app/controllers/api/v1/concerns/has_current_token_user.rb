# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module HasCurrentTokenUser
        extend ActiveSupport::Concern

        included do
          before_action :verify_current_token_user
        end

        private

        def verify_current_token_user
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
end
