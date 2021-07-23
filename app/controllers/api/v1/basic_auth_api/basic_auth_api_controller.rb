# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class BasicAuthApiController < ApiController
        include ::IsBasicAuthenticated
      end
    end
  end
end
