# frozen_string_literal: true

module Api
  module V1
    class ProtocolController < ApiController
      include ::Concerns::IsLoggedIn

      def index
        # TODO: We should make this selection smaller. We'd probably like to
        # introduce something like a bounded protocol, which is only available
        # to the current organization / group of people.
        render json: Protocol.all, each_serializer: Api::ProtocolSerializer
      end
    end
  end
end
