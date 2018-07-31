# frozen_string_literal: true

require 'httparty'
require 'compsy/microservice_api/sessions/basic_auth_session'

module Compsy
  module MicroserviceApi
    def self.basic_auth_session(*arguments, &block)
      Sessions::BasicAuthSession.new(*arguments, &block)
    end
  end
end
