# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class OneTimeResponseController < JwtApiController
        before_action :load_one_time_response, only: :show
        before_action :subscribe_person, only: :show

        def show
          redirect_to @one_time_response.redirect_url(current_user)
        end

        def index
          render json: OneTimeResponse.all
        end

        private

        def subscribe_person
          @one_time_response.subscribe_person(current_user, nil)
        end

        def mentor
          @mentor ||= Person.find_by(id: protocol_subscription_create_params[:mentor_id])
        end

        def load_one_time_response
          token = one_time_response_params[:token]
          @one_time_response = OneTimeResponse.find_by(token: token)
          return @one_time_response if @one_time_response.present?

          render(status: :not_found, json: 'De vragenlijst kon niet gevonden worden.')
        end

        def one_time_response_params
          params.permit(:token)
        end
      end
    end
  end
end
