# frozen_string_literal: true

module Api
  module V1
    module ApiToken
      class ApiTokenApiController < ApiController
        include ::Concerns::IsBasicAuthenticated
      end
    end
  end
end
