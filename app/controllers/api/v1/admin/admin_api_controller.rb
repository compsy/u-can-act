# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < ApiController
        include Knock::Authenticable
        before_action :authenticate_admin

        private

        def unauthorized_entity(_entity_name)
          render json: { error: 'Unauthorized request' }, status: :unauthorized
        end
      end
    end
  end
end
