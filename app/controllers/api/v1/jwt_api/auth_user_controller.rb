# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class AuthUserController < JwtApiController
        def create
          render json: current_auth_user, serializer: Api::AuthUserSerializer
        end
      end
    end
  end
end
