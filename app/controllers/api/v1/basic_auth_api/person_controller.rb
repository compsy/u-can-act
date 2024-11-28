# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class PersonController < BasicAuthApiController
        before_action :set_person, only: %i[change_to_mentor]
        before_action :set_person_by_auth0_id_string, only: %i[destroy update]
        before_action :set_mentor_role, only: %i[change_to_mentor]

        # rubocop:disable Metrics/AbcSize
        def create
          begin
            auth_user = AuthUser.from_token_payload(new_person_params)
          rescue RuntimeError => e
            return validation_error(e.message) if team_error?(e)

            # If we don't recognize the error raise it so AppSignal notifies us about it
            raise e
          end
          # This endpoint was added for UMO, where we need to sync users and we need their real emails stored so we can
          # invite them to fill in questionnaires. AuthUser.from_token_payload creates a new anonymous user (with no
          # email), so we need to add it manually
          auth_user.person.update(email: new_person_params[Rails.application.config.settings.metadata_field][:email])

          return created(auth_user.person) if auth_user.person.valid?

          validation_error(auth_user.person.errors)
        rescue ActionController::ParameterMissing => e
          validation_error(e.message)
        end
        # rubocop:enable Metrics/AbcSize

        def update
          @person.update(updateable_person_params)
          render_resource(@person)
        end

        def destroy
          @person.destroy
          destroyed
        end

        def show_list
          auth_users = AuthUser.where(auth0_id_string: person_params[:person_auth0_ids])
          render status: :ok, json: auth_users.map(&:person), each_serializer: Api::PersonSerializer
        end

        def change_to_mentor
          @person.update!(role: @mentor_role)

          render json: { status: 'Person changed to mentor' }, status: :ok
        end

        private

        def updateable_person_params
          params.require(:person).permit(:mobile_phone, :first_name, :last_name, :email)
        end

        def person_params
          params.permit(person_auth0_ids: [])
        end

        def set_person
          @person = Person.find_by(id: params[:id])
          return if @person

          render json: { error: 'No such person found' }, status: :not_found
        end

        def set_person_by_auth0_id_string
          @person = AuthUser.find_by(auth0_id_string: params[:id])&.person
          return if @person.present?

          render json: { error: 'No such person found' }, status: :not_found
        end

        def set_mentor_role
          @mentor_role = Organization.first&.teams&.first&.roles&.where(group: Person::MENTOR)&.first
          return if @mentor_role

          render json: { error: 'Cannot assign mentor role: mentor role does not exist' }, status: :bad_request
        end

        def new_person_params
          params.require(:person).permit :sub,
                                         Rails.application.config.settings.metadata_field => %i[team role email]
        end

        def team_error?(error)
          /
             (Team\s'.*'\snot\sfound)|
             (Team\s'.*'\shas\sno\sroles)|
             (Specified\srole\s'.*'\snot\sfound\sin\steam)|
             (Required\spayload\sattribute\steam\snot\sspecified)
          /x.match?(error.message)
        end
      end
    end
  end
end
