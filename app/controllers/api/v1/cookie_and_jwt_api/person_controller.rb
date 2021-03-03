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

        # If we are sent an empty string as an email, set it to nil instead. Because we do
        # uniqueness checking on the email, having multiple people with an empty string as
        # email is not allowed, but having multiple people with a nil email is allowed.
        # The same applies to mobile phone numbers.
        def overwritten_params
          result = {}
          %i[email mobile_phone].each do |param|
            result[param] = nil if person_params.key?(param) && !person_params[param].present?
          end
          result
        end

        def update_person
          timestamp = person_params[:timestamp].present? ? Time.zone.parse(person_params[:timestamp]) : nil
          # no timestamp: request is synchronous
          # if timestamp: request is async, so check if it is the most recent one
          if timestamp.blank? || timestamp > current_user.updated_at
            return current_user.update(person_params.except(:timestamp).merge(overwritten_params))
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
