# frozen_string_literal: true

module Api
  module V1
    module CookieAndJwtApi
      class ProtocolSubscriptionsController < CookieAndJwtApiController
        before_action :set_protocol_subscription, only: %i[show]
        before_action :verify_access, only: %i[show]

        def show
          render json: @protocol_subscription, serializer: Api::ProtocolSubscriptionSerializer
        end

        # Specify either a start_date or a start_time. A given start_date takes precedence.
        # If a start_time is specified (and no start_date is specified),
        # the start_date is chosen as the given start_time added to midnight the next day.
        def create
          result = SubscribeToProtocol.run!(
            protocol_name: protocol_subscription_create_params[:protocol_name],
            person: current_user,
            start_date: start_date,
            only_if_not_subscribed: true
          )
          render status: :created, json: result
        end

        private

        def verify_access
          return if check_access_allowed(@protocol_subscription)

          access_denied(protocol_subscription: 'U heeft geen toegang tot deze protocolsubscriptie')
        end

        def set_protocol_subscription
          @protocol_subscription = ProtocolSubscription.find_by(id: params[:id])
          return if @protocol_subscription.present?

          not_found(protocol_subscription: 'Protocol subscription met dat ID niet gevonden')
        end

        def start_date
          return start_time if protocol_subscription_create_params[:start_date].blank?

          Time.zone.parse(protocol_subscription_create_params[:start_date])
        end

        def start_time
          return Time.zone.now if no_start_time_given

          next_midnight = TimeTools.increase_by_duration(Time.zone.now.beginning_of_day, 1.day)
          TimeTools.increase_by_duration(next_midnight, protocol_subscription_create_params[:start_time].to_i)
        end

        def no_start_time_given
          protocol_subscription_create_params[:start_time].blank? ||
            (protocol_subscription_create_params[:start_time].to_i.zero? &&
              protocol_subscription_create_params[:start_time] != '0')
        end

        def protocol_subscription_create_params
          params.permit(:protocol_name, :start_date, :start_time)
        end
      end
    end
  end
end
