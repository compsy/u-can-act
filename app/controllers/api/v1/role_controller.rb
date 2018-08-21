# frozen_string_literal: true

module Api
  module V1
    class RoleController < ApiController
      include ::Concerns::IsLoggedIn
      include ::Concerns::IsLoggedInAsMentor

      def index
        render json: current_user.role.team.roles.where(group: Person::STUDENT), each_serializer: Api::RoleSerializer
      end
    end
  end
end
