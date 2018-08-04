# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < ApiController
        include ::Concerns::IsJwtAuthenticated
        before_action :check_admin_authenticated

        def check_admin_authenticated
          return if current_auth_user.role == AuthUser::ADMIN_ROLE
          result = { result: 'User is not an admin' }

          render(status: 403, json: result)
        end
      end
    end
  end
end
