# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Knock::Authenticable
      skip_before_action :verify_authenticity_token

      private

      def unauthorized_entity(entity_name)
        # Without specifying a scope, active model serializers tries to call the method "current_user",
        # which fails and gives a different error.
        render json: { error: "#{entity_name} Unauthorized request" }, scope: :current_user,
               status: :unauthorized
      end

      def unprocessable_entity(resource_errors)
        render json: {
          errors: [
            {
              status: '422',
              title: 'unprocessable',
              detail: resource_errors,
              code: '100'
            }
          ]
        }, status: :unprocessable_entity
      end

# rubocop:disable Style/BlockComments
=begin
      # This function can be enabled when debugging the authentication
      # currently it is implemented by know authenticable
      def define_current_entity_getter(entity_class, getter_name)
        unless respond_to?(getter_name)
          memoization_var_name = "@_#{getter_name}"
          self.class.send(:define_method, getter_name) do
            unless instance_variable_defined?(memoization_var_name)
              current =
                begin
                  Knock::AuthToken.new(token: token).entity_for(entity_class)
                rescue Knock.not_found_exception_class, JWT::DecodeError, JWT::EncodeError
                  nil
                end
              instance_variable_set(memoization_var_name, current)
            end
            instance_variable_get(memoization_var_name)
          end
        end
      end
=end
      # rubocop:enable Style/BlockComments

      # Called from the middleware!
      def raise_bad_request
        render plain: "Error while parsing json parameters: #{request.env['RAW_POST_DATA']}", status: :bad_request
      end

      def check_access_allowed(protocol_subscription)
        return false if current_user.blank?

        current_user_has_access = protocol_subscription.person == current_user
        current_mentor_has_access = protocol_subscription.person.mentor == current_user

        current_mentor_has_access || current_user_has_access
      end
    end
  end
end
