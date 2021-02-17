# frozen_string_literal: true

module Api
  module V1
    module CookieAndJwtApi
      class CookieAndJwtApiController < ApiController
        include ::IsLoggedInWithAnyMethod
      end
    end
  end
end
