# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class ProtocolSubscriptionsController < BasicAuthApiController
        before_action :set_person, only: %i[create]
        before_action :set_external_identifier, only: %i[delegated_protocol_subscriptions destroy]
        before_action :set_protocol_subscription, only: %i[destroy]

        def show_for_mentor
          mentor.my_protocols(false)
        end

        def create
          result = SubscribeToProtocol.run!(
            protocol_name: protocol_subscription_create_params[:protocol_name],
            person: @person,
            start_date: start_date,
            end_date: end_date,
            mentor: mentor,
            external_identifier: external_identifier
          )
          SendInvitations.run
          render status: :created, json: result
        end

        def delegated_protocol_subscriptions
          render json: ProtocolSubscription.active.where(external_identifier: @external_identifier),
                 each_serializer: Api::ProtocolSubscriptionSerializer
        end

        # This cancels the protocol subscription. Only works if the external_identifier is given.
        def destroy
          @protocol_subscription.cancel!
          destroyed
        end

        private

        def set_protocol_subscription
          @protocol_subscription = ProtocolSubscription.find_by(id: params[:id],
                                                                external_identifier: @external_identifier)
          return if @protocol_subscription.present?

          not_found(protocol_subscription: 'Protocol subscription met dat ID niet gevonden')
        end

        def start_date
          return Time.zone.now if protocol_subscription_create_params[:start_date].blank?

          # The start date cannot be in the past.
          temp_start_date = Time.zone.parse(protocol_subscription_create_params[:start_date])
          return Time.zone.now if temp_start_date <= Time.zone.now

          temp_start_date
        end

        def end_date
          return nil if protocol_subscription_create_params[:end_date].blank?

          # The duration between start and end date should be at least one hour.
          minimum_end_date = TimeTools.increase_by_duration(start_date, 1.hour)

          [Time.zone.parse(protocol_subscription_create_params[:end_date]), minimum_end_date].max
        end

        def mentor
          @mentor ||= Person.find_by(id: protocol_subscription_create_params[:mentor_id])
        end

        def external_identifier
          return nil if protocol_subscription_create_params[:external_identifier].blank?

          protocol_subscription_create_params[:external_identifier]
        end

        def set_external_identifier
          @external_identifier = params[:external_identifier]
          return if @external_identifier.present?

          unprocessable_entity(external_identifier: 'required')
        end

        def set_person
          @auth_user ||= AuthUser.find_by(auth0_id_string: protocol_subscription_create_params[:auth0_id_string])
          @person = @auth_user&.person

          return if @person.present?

          render(status: :not_found, json: 'Person met dat ID niet gevonden')
        end

        def protocol_subscription_create_params
          params.permit(:protocol_name, :auth0_id_string, :start_date, :end_date, :mentor_id, :external_identifier)
        end
      end
    end
  end
end
