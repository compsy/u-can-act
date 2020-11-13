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
          res = update_person
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

        def update_person
          timestamp = person_params[:timestamp] and person_params[:timestamp].to_datetime
          # no timestamp: request is synchronous
          # if timestamp: request is async, so check if it is the most recent one
          if timestamp.nil? || (timestamp > current_user.updated_at)
            return current_user.update(person_params.except(:timestamp))
          end

          nil
        end

        def person_params
          params.require(:person).permit(:mobile_phone, :email, :account_active, :locale, :timestamp)
        end
      end
    end
  end
end
