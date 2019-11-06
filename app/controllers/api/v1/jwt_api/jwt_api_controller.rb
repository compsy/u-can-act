# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class JwtApiController < ApiController
        include ::Concerns::IsJwtAuthenticated
      end
    end
  end
end
