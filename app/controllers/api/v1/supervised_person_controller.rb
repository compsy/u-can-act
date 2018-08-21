# frozen_string_literal: true

module Api
  module V1
    class SupervisedPersonController < ApiController
      include ::Concerns::IsLoggedIn
      before_action :check_role_id_for_created_person, only: [:create]
      before_action :load_role
      before_action :load_supervision_trajectory
      before_action :load_start_date
      before_action :load_end_date
      before_action :check_person_params

      def create
        person = nil
        ActiveRecord::Base.transaction do
          person = create_person
          return if performed?
          @supervision_trajectory.subscribe!(student: person,
                                             mentor: current_user,
                                             start_date: @start_date,
                                             end_date: @end_date)
        end
        render json: person, serializer: Api::PersonSerializer, status: 201
      end

      private

      def create_person
        person = Person.new(person_params)
        person.role = @role
        return person if person.save
        render json: { errors: person.errors.full_messages }, status: 422
      end

      def check_person_params
        errors = {}
        errors[:first_name] = 'niet gevonden' unless person_params[:first_name].present?
        errors[:last_name] = 'niet gevonden' unless person_params[:first_name].present?
        render json: { errors: { supervision_trajectory_uuid: ['niet gevonden'] } }, status: 422 unless @supervision_trajectory.present?
      end

      def check_role_id_for_created_person
        return unless check_correct_rights
        return unless check_valid_role
      end

      def check_valid_role
        roles = current_user.role.team.roles.where(group: Person::STUDENT)

        # to_s because the rest call gives us a string
        if roles.any? { |role| role.uuid.to_s == @role }
          head 403
          return false
        end
        true
      end

      def check_correct_rights
        # Mentors can currently only create persons that are students in their own
        # organization!
        if current_user.role.group != Person::MENTOR
          head 403
          return false
        end
        true
      end

      def load_supervision_trajectory
        @supervision_trajectory = SupervisionTrajectory.find_by_uuid(supervision_trajectory_params[:uuid])
        render json: { errors: { supervision_trajectory_uuid: ['niet gevonden'] } }, status: 422 unless @supervision_trajectory.present?
      end

      def load_role
        @role = Role.find_by_uuid(role_params[:uuid])
        render json: { errors: { role_uuid: ['niet gevonden'] } }, status: 422 unless @role.present?
      end

      def role_params
        params.require(:role).permit(:uuid)
      end

      def supervision_trajectory_params
        params.require(:supervision_trajectory).permit(:uuid)
      end

      def protocol_params
        params.require(:protocol).permit(:start_date, :end_date)
      end

      def load_start_date
        if params[:protocol].blank? || protocol_params[:start_date].blank?
          render json: { errors: ['Start date is niet correct'] }, status: 422
          return
        end
        @start_date = Date.parse(protocol_params[:start_date]).in_time_zone.beginning_of_week
      end

      def load_end_date
        if params[:protocol].blank? || protocol_params[:end_date].blank?
          render json: { errors: ['End date is niet correct'] }, status: 422
          return
        end
        @end_date = Date.parse(protocol_params[:end_date]).in_time_zone.beginning_of_week
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
