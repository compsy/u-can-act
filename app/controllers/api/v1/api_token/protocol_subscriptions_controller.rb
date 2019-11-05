# frozen_string_literal: true

module Api
  module V1
    module ApiToken
      class ProtocolSubscriptionsController < ApiTokenApiController
        before_action :set_person, only: %i[create]

        def create
          result = SubscribeToProtocol.run!(
            protocol_name: protocol_subscription_create_params[:protocol_name],
            person: @person,
            start_date: protocol_subscription_create_params[:start_date] || Time.zone.now
          )
          render json: result
        end

        private

        def set_person
          @auth_user ||= AuthUser.find_by(auth0_id_string: protocol_subscription_create_params[:auth0_id_string])
          @person = @auth_user&.person

          return if @person.present?

          render(status: :not_found, json: 'Person met dat ID niet gevonden')
        end

        def protocol_subscription_create_params
          params.permit(:protocol_name, :auth0_id_string, :start_date)
        end
      end
    end
  end
end
