# frozen_string_literal: true

require 'active_interaction'
require 'compsy/microservice_api/version'
require 'compsy/microservice_api/sessions'
require 'compsy/microservice_api/models'
require 'compsy/microservice_api/endpoint'
require 'compsy/microservice_api/call_service'

module Compsy
  module MicroserviceApi
    # Raised when a request failed due to an expired/non-existant session.
    class NoSession < StandardError; end
    class Unauthorized < StandardError; end
  end
end
