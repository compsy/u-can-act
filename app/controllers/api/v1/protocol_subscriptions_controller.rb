# frozen_string_literal: true

module Api
  module V1
    class ProtocolSubscriptionsController < ApiController
      # include ::Concerns::IsLoggedIn
      include ::Concerns::IsLoggedInWithAnyMethod

      before_action :set_protocol_subscription, only: %i[show]
      before_action :verify_access, only: %i[show]

      def mine
        render json: current_user.protocol_subscriptions, each_serializer: Api::ProtocolSubscriptionSerializer
      end

      def show
        render json: @protocol_subscription, serializer: Api::ProtocolSubscriptionSerializer
      end

      private

      def verify_access
        allowed = check_access_allowed(@protocol_subscription)
        render(status: :forbidden, json: 'U heeft geen toegang tot deze protocolsubscriptie') unless allowed
      end

      def set_protocol_subscription
        @protocol_subscription = ProtocolSubscription.find_by(id: params[:id])
        return if @protocol_subscription.present?

        render(status: :not_found, json: 'Protocol subscription met dat ID niet gevonden')
      end
    end
  end
end
