# frozen_string_literal: true

# TODO: HOW TO DEAL WITH AUTHENTICATION HERE? SAME AS IN THE OTHER CONTROLLERS?
module Api
  module V1
    class RewardsController < ApiController
      before_action :set_protocol_subscription, only: %i[show]
      before_action :verify_access, only: %i[show]
      def show
        render json: @protocol_subscription, serializer: Api::RewardSerializer
      end

      private

      def verify_access
        allowed = check_access_allowed(@protocol_subscription)
        render(status: 403, json: 'You are not allowed to access this response!') unless allowed
      end

      def set_protocol_subscription
        @protocol_subscription = ProtocolSubscription.find_by_id(params[:id])
        return if @protocol_subscription.present?
        render(status: 404, plain: 'Protocol subscription with that id not found')
      end
    end
  end
end
