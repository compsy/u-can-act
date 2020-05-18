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

        delegate :my_students, to: :current_user

        def update
          res = current_user.update(person_params)
          if res
            render status: :ok, json: { status: 'ok' }
          else
            unprocessable_entity(current_user.errors)
          end
        end

        def destroy
          current_user.destroy!
          render status: :ok, json: { status: 'ok' }
        end

        private

        def person_params
          params.require(:person).permit(:mobile_phone, :email, :account_active, :locale)
        end
      end
    end
  end
end
