# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class ProtocolSubscriptionsController < BasicAuthApiController
        include ProtocolHelper

        before_action :set_person, only: %i[create destroy_delegated_protocol_subscriptions]
        before_action :set_external_identifier, only: %i[delegated_protocol_subscriptions destroy update
                                                         destroy_delegated_protocol_subscriptions]
        before_action :set_protocol_subscription, only: %i[destroy update]

        def show_for_mentor
          mentor.my_protocols(false)
        end

        # rubocop:disable Metrics/AbcSize
        def create
          result = SubscribeToProtocol.run!(
            protocol_name: protocol_subscription_create_params[:protocol_name],
            person: @person,
            start_date: start_date(protocol_subscription_create_params[:start_date]),
            end_date: end_date(protocol_subscription_create_params[:start_date],
                               protocol_subscription_create_params[:end_date]),
            mentor: mentor,
            external_identifier: external_identifier,
            invitation_text_nl: protocol_subscription_create_params[:invitation_text_nl],
            invitation_text_en: protocol_subscription_create_params[:invitation_text_en],
            open_from_day_uses_start_date_offset:
              protocol_subscription_create_params[:open_from_day_uses_start_date_offset],
            needs_language_input: protocol_subscription_create_params[:needs_language_input]
          )
          SendInvitations.run
          render status: :created, json: result
        end
        # rubocop:enable Metrics/AbcSize

        def delegated_protocol_subscriptions
          render json: ProtocolSubscription.where(external_identifier: @external_identifier)
                                           .includes(:person, :protocol, :responses),
                 each_serializer: Api::ProtocolSubscriptionSerializer
        end

        def destroy_delegated_protocol_subscriptions
          ProtocolSubscription.active.where(person: @person,
                                            external_identifier: @external_identifier).each(&:cancel!)
          destroyed
        end

        # This cancels the protocol subscription. Only works if the external_identifier is given.
        def destroy
          @protocol_subscription.cancel!
          destroyed
        end

        # This updates the protocol subscription. Only works if the external_identifier is given.
        # We reschedule the responses with a date that is in the future, for the same reasoning
        # as is explained in reschedule_responses.rb.
        def update
          res = @protocol_subscription.update(protocol_subscription_update_params)
          return unprocessable_entity(@protocol_subscription.errors) unless res

          RescheduleResponses.run!(protocol_subscription: @protocol_subscription,
                                   future: TimeTools.increase_by_duration(Time.zone.now, 1.hour))
          render status: :ok, json: { status: 'ok' }
        end

        private

        def set_protocol_subscription
          @protocol_subscription = ProtocolSubscription.active.find_by(id: params[:id],
                                                                       external_identifier: @external_identifier)
          return if @protocol_subscription.present?

          not_found(protocol_subscription: 'Protocol subscription met dat ID niet gevonden')
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
          params.permit(:protocol_name, :auth0_id_string, :start_date, :end_date, :mentor_id, :external_identifier,
                        :invitation_text_nl, :invitation_text_en, :open_from_day_uses_start_date_offset,
                        :needs_language_input)
        end

        def protocol_subscription_update_params
          params.permit(:end_date)
        end
      end
    end
  end
end
