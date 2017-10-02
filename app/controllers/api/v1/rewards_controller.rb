# frozen_string_literal: true

#TODO: HOW TO DEAL WITH AUTHENTICATION HERE? SAME AS IN THE OTHER CONTROLLERS?
module Api
  module V1
    class RewardsController < ApiController
      before_action :set_protocol_subscription, only: %i[show]
      def show
        # How much the person has earned
        # How much you can still earn
        # FE: Create bar filled with green (no red), parts still achievable $
        # Winstreak when 5 questionnaires are filled out at a time
        render json: @protocol_subscription, serializer: Api::RewardSerializer
      end

      private

      def set_protocol_subscription
        @protocol_subscription = ProtocolSubscription.find(params[:id])
        return if @protocol_subscription.present?
        render(status: 404, plain: 'Protocol subscription with that id not found')
      end
    end
  end
end
