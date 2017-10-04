# frozen_string_literal: true

# TODO: HOW TO DEAL WITH AUTHENTICATION HERE? SAME AS IN THE OTHER CONTROLLERS?
module Api
  module V1
    class RewardsController < ApiController
      before_action :set_protocol_subscription, only: %i[show]
      def show
        check_access_allowed(@protocol_subscription)
        render json: @protocol_subscription, serializer: Api::RewardSerializer
      end

      private

      def verify_response_completed(response)
        return if response.completed_at.present?
        render(status: 400, json: 'Not available when the questionnaire is not yet completed')
      end

      def set_protocol_subscription
        @protocol_subscription = ProtocolSubscription.find(params[:id])
        return if @protocol_subscription.present?
        render(status: 404, plain: 'Protocol subscription with that id not found')
      end
    end
  end
end
