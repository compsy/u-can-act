# frozen_string_literal: true

module Api
  module V1
    class PersonController < ApiController
      # This class is currently being used in the IBAN notification. I.e., we need to
      # support cookie authentication.
      include ::Concerns::IsLoggedInWithAnyMethod

      def test
        AuthUser.destroy_all
        render json: 'hoi'
      end

      def me
        render json: current_user, serializer: Api::PersonSerializer
      end

      def update
        current_user.update!(person_params)
      end

      private

      def person_params
        params.require(:person).permit(:mobile_phone, :email)
      end
    end
  end
end
