# frozen_string_literal: true

module Api
  module V1
    class PersonController < ApiController
      include ::Concerns::IsLoggedIn

      def me
        render json: current_user, serializer: Api::PersonSerializer
      end

      def create; end
    end
  end
end
