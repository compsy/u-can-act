# frozen_string_literal: true

module Api
  module V1
    class PersonController < ApiController
      # This class is currently being used in the IBAN notification. I.e., we need to
      # support cookie authentication.
      include ::Concerns::IsLoggedIn

      def me
        render json: current_user, serializer: Api::PersonSerializer
      end
    end
  end
end
