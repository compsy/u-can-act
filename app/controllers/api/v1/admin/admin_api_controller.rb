# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < ApiController
        include ::IsJwtAuthenticated
        before_action :check_admin_authenticated

        def check_admin_authenticated
          return if current_auth_user.access_level == AuthUser::ADMIN_ACCESS_LEVEL

          result = { result: 'User is not an admin' }

          render(status: :forbidden, json: result)
        end
      end
    end
  end
end
