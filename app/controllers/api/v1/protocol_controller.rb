# frozen_string_literal: true

module Api
  module V1
    class ProtocolController < ApiController
      include ::Concerns::IsJwtAuthenticated

      def index
        render json: Protocol.all
      end
    end
  end
end
