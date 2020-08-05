# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class ProtocolSubscriptionsController < JwtApiController
        def mine
          render json: current_user.my_protocols(true),
                 each_serializer: Api::ProtocolSubscriptionSerializer
        end
      end
    end
  end
end
