# frozen_string_literal: true

module Api
  module V1
    class ProtocolSubscriptionsController < ApiController
      include ::Concerns::IsLoggedIn

      before_action :set_protocol_subscription, only: %i[show]
      before_action :verify_access, only: %i[show]

      def show
        render json: @protocol_subscription, serializer: Api::ProtocolSubscriptionSerializer
      end

      private

      def verify_access
        allowed = check_access_allowed(@protocol_subscription)
        render(status: 403, json: 'U heeft geen toegang tot deze protocolsubscriptie') unless allowed
      end

      def set_protocol_subscription
        @protocol_subscription = ProtocolSubscription.find_by_id(params[:id])
        return if @protocol_subscription.present?

        render(status: 404, html: 'Protocol subscription met dat ID niet gevonden', layout: 'application')
      end
    end
  end
end
