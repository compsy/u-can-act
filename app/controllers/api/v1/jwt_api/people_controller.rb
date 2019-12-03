# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class PeopleController < JwtApiController
        before_action :set_email, only: %i[create]
        before_action :check_email, only: %i[create]
        before_action :set_parent, only: %i[create]
        before_action :set_team_name, only: %i[create]
        before_action :set_first_name, only: %i[create]
        before_action :set_role_title, only: %i[create]
        before_action :set_children, only: %i[list_children]
        before_action :set_child, only: %i[update_child destroy_child]

        def create
          @person = CreateChildPerson.run!(
            parent: @parent,
            email: @email,
            team_name: @team_name,
            first_name: @first_name,
            role_title: @role_title
          )
          SendRegistrationEmailJob.perform_later(@person)
          render json: { status: 'Person created' }, status: :ok
        end

        def list_children
          render json: @children, each_serializer: Api::ChildSerializer
        end

        def update_child
          @child = UpdateChildPerson.run(update_child_params.merge(person: @child))
          if @child.valid?
            render json: @child, serializer: Api::ChildSerializer, status: :ok
          else
            render json: @child.errors, status: :bad_request
          end
        end

        def destroy_child
          @child.destroy!
          render json: { status: 'Child destroyed' }, status: :ok
        end

        private

        def set_child
          @child = Person.find_by(id: params[:id], parent: current_auth_user.person)
          return if @child.present?

          render json: { error: 'No child with specified ID found' }, status: :not_found
        end

        def update_child_params
          params.permit(:email, :first_name, :role)
        end

        def set_children
          @children = Person.where(parent: current_auth_user.person)
        end

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
