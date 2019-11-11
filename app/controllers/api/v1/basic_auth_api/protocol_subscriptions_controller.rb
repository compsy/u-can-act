# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class ProtocolSubscriptionsController < BasicAuthApiController
        before_action :set_person, only: %i[create]
        before_action :set_mentor, only: %i[show_for_mentor]

        def show_for_mentor
          @mentor.my_protocols(false)
        end

        def create
          result = SubscribeToProtocol.run!(
            protocol_name: protocol_subscription_create_params[:protocol_name],
            person: @person,
            start_date: start_date,
            mentor: mentor_id
          )
          render json: result
        end

        private

        def start_date
          return Time.zone.now if protocol_subscription_create_params[:start_date].blank?

          Time.zone.parse(protocol_subscription_create_params[:start_date])
        end

        def set_mentor
          @mentor ||= Person.find_by(protocol_subscription_create_params[:mentor_id])
          return if @mentor.present?

          render(status: :not_found, json: 'Person met dat ID niet gevonden')
        end

        def set_person
          @auth_user ||= AuthUser.find_by(auth0_id_string: protocol_subscription_create_params[:auth0_id_string])
          @person = @auth_user&.person

          return if @person.present?

          render(status: :not_found, json: 'Person met dat ID niet gevonden')
        end

        def protocol_subscription_create_params
          params.permit(:protocol_name, :auth0_id_string, :start_date, :mentor_id)
        end
      end
    end
  end
end
