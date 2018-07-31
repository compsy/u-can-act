# frozen_string_literal: true

module Compsy
  module MicroserviceApi
    # @api private
    class Endpoint < ActiveInteraction::Base
      object :basic_auth_session,
             default: -> { MicroserviceApi.basic_auth_session },
             class: Compsy::MicroserviceApi::Sessions::BasicAuthSession

      private

      def validate_response_for
        response = yield
        if response.parsed_response.is_a?(Hash) && response['errors'].present?
          deal_with_errors(response)
          return nil
        end

        if response.code == 422
          errors.add :base, 'Validations failed!'
          return nil
        end

        response_to_result response
      end

      def deal_with_errors(response)
        response['errors'].each do |attribute, attribute_errors|
          attribute_errors.each do |error|
            add_error(attribute, error)
          end
        end
      end

      def add_error(attribute, error)
        if respond_to?(attribute.to_sym) || attribute.to_sym == :base
          errors.add attribute.to_sym, error.to_sym
        else
          errors.add :base, [attribute, error].join('_').to_sym
        end
      end

      def response_to_result(response)
        response
      end
    end
  end
end
