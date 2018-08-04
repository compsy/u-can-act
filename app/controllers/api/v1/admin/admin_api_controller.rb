# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < ApiController
        include ::Concerns::IsJwtAuthenticated
        before_action :check_admin_authenticated

        def check_admin_authenticated
          result = { result: 'Not implemented, check if the user has the correct role' }
          render(status: 403, json: result)
        end
      end
    end
  end
end
