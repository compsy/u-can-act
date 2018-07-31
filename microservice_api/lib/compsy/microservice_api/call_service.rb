# frozen_string_literal: true

module Compsy
  module MicroserviceApi
    # @api private
    class CallService < Endpoint
      string :action
      string :namespace
      hash :parameters, strip: false, default: nil
      def execute
        validate_response_for do
          basic_auth_session.post "/namespaces/#{namespace}/actions/#{action}", parameters
        end
      end

      def response_to_result(response)
        Models::Result.new(response)
      end
    end
  end
end
