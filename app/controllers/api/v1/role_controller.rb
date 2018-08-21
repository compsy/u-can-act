# frozen_string_literal: true

module Api
  module V1
    class RoleController < ApiController
      include ::Concerns::IsLoggedIn
      before_action :check_correct_rights, only: [:index]

      def index
        render json: current_user.role.team.roles.where(group: Person::STUDENT), each_serializer: Api::RoleSerializer
      end

      private

      def check_correct_rights
        # Mentors can currently only create persons that are students in their own
        # organization!
        if current_user.role.group != Person::MENTOR
          head 403
          return false
        end
        true
      end
    end
  end
end
