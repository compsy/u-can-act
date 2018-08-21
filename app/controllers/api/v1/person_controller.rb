# frozen_string_literal: true

module Api
  module V1
    class PersonController < ApiController
      include ::Concerns::IsLoggedIn
      include ::Concerns::IsLoggedInAsMentor
      before_action :load_role, only: [:create]
      before_action :check_valid_role, only: [:create]

      def me
        render json: current_user, serializer: Api::PersonSerializer
      end

      def create
        person = Person.new(person_params)
        person.role = @role
        if person.save
          render json: person, serializer: Api::PersonSerializer, status: 201
        else
          render json: { errors: person.errors }, status: 422
        end
      end

      private

      def check_valid_role
        roles = current_user.role.team.roles.where(group: Person::STUDENT)

        # to_s because the rest call gives us a string
        role_uuids = roles.map { |role| role.uuid.to_s }

        if role_uuids.exclude? @role.uuid
          head 403
          return false
        end
        true
      end

      def load_role
        @role = Role.find_by_uuid(role_params[:uuid])
      end

      def role_params
        params.require(:role).permit(:uuid)
      end

      def person_params
        params.require(:person).permit(:first_name,
                                       :last_name,
                                       :email,
                                       :gender,
                                       :mobile_phone)
      end
    end
  end
end
