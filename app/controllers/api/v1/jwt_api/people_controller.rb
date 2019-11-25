# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class PeopleController < JwtApiController
        before_action :set_email
        before_action :check_email
        before_action :set_parent
        before_action :set_team_name
        before_action :set_first_name
        before_action :set_role_title

        def create
          @person = CreateChildPerson.run!(
            parent: @parent,
            email: @email,
            team_name: @team_name,
            first_name: @first_name,
            role_title: @role_title
          )
          EmailRegistration.run!(person: @person)
          render json: { status: 'Person created' }, status: :ok
        end

        private

        def person_create_params
          params.permit(:email, :team, :role, :first_name)
        end

        def set_email
          @email = person_create_params[:email]
          return if @email.present?

          render json: { error: 'Email address for creating a person was not specified' }, status: :bad_request
        end

        def check_email
          person = Person.find_by(email: @email)
          return if person.blank?

          render json: { error: 'A person already exists with the specified email address' }, status: :bad_request
        end

        def set_parent
          @parent = current_auth_user.person
          return if @parent.present?

          render json: { error: 'The logged-in parent user does not have a person object' }, status: :bad_request
        end

        def set_team_name
          @team_name = person_create_params[:team]
          return if @team_name.present?

          render json: { error: 'Team for creating a person was not specified' }, status: :bad_request
        end

        def set_role_title
          @role_title = person_create_params[:role]
          return if @role_title.present?

          render json: { error: 'Role for creating a person was not specified' }, status: :bad_request
        end

        def set_first_name
          @first_name = person_create_params[:first_name]
          return if @first_name.present?

          render json: { error: 'First name for creating a person was not specified' }, status: :bad_request
        end
      end
    end
  end
end
