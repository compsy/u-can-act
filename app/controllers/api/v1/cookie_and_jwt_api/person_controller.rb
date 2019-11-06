# frozen_string_literal: true

module Api
  module V1
    module CookieAndJwtApi
      class PersonController < CookieAndJwtApiController
        # This class is currently being used in the IBAN notification. I.e., we need to
        # support cookie authentication.
        def me
          render json: current_user, serializer: Api::PersonSerializer
        end

        def update
          res = current_user.update(person_params)
          if res
            render status: :ok, json: { status: 'ok' }
          else
            render status: :unprocessable_entity, json: { status: 'not ok', errors: current_user.errors }
          end
        end

        private

        def person_params
          params.require(:person).permit(:mobile_phone, :email)
        end
      end
    end
  end
end
