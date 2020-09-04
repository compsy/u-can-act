# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class PersonController < BasicAuthApiController
        before_action :set_person, only: %i[change_to_mentor]
        before_action :set_mentor_role, only: %i[change_to_mentor]

        def show_list
          auth_users = AuthUser.where(auth0_id_string: person_params[:person_auth0_ids])
          render status: :ok, json: auth_users.map(&:person), each_serializer: Api::PersonSerializer
        end

        def change_to_mentor
          @person.update!(role: @mentor_role)

          render json: { status: 'Person changed to mentor' }, status: :ok
        end

        private

        def person_params
          params.permit(person_auth0_ids: [])
        end

        def set_person
          @person = Person.find_by(id: params[:id])
          return if @person

          render json: { error: 'No such person found' }, status: :not_found
        end

        def set_mentor_role
          @mentor_role = Organization.first&.teams&.first&.roles&.where(group: Person::MENTOR)&.first
          return if @mentor_role

          render json: { error: 'Cannot assign mentor role: mentor role does not exist' }, status: :bad_request
        end
      end
    end
  end
end
