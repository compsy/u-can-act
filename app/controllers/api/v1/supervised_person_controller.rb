# frozen_string_literal: true

module Api
  module V1
    class SupervisedPersonController < ApiController
      include ::Concerns::IsLoggedIn
      include ::Concerns::IsLoggedInAsMentor
      before_action :load_role
      before_action :check_valid_role, only: [:create]
      before_action :load_supervision_trajectory
      before_action :load_start_date
      before_action :load_end_date
      before_action :check_person_params

      def create
        ActiveRecord::Base.transaction do
          person = create_person
          return if performed?
          @supervision_trajectory.subscribe!(student: person,
                                             mentor: current_user,
                                             start_date: @start_date,
                                             end_date: @end_date)
          render json: person, serializer: Api::PersonSerializer, status: 201
        end
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
        errors[:first_name] = ['not found'] unless person_params[:first_name].present?
        errors[:last_name] = ['not found'] unless person_params[:last_name].present?
        render json: { errors: errors }, status: 422 unless errors.blank?
      end

      def check_valid_role
        roles = current_user.role.team.roles.where(group: Person::STUDENT)

        # to_s because the rest call gives us a string
        return if roles.any? { |role| role.uuid.to_s == @role.uuid }
        render json: { errors: { role_uuid: ['not allowed'] } }, status: 403
      end

      def load_supervision_trajectory
        @supervision_trajectory = SupervisionTrajectory.find_by_uuid(supervision_trajectory_params[:uuid])
        return if @supervision_trajectory.present?
        render json: { errors: { supervision_trajectory_uuid: ['not found'] } }, status: 422
      end

      def load_role
        @role = Role.find_by_uuid(role_params[:uuid])
        render json: { errors: { role_uuid: ['not found'] } }, status: 422 unless @role.present?
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
          render json: { errors: { start_date: ['incorrect or missing'] } }, status: 422
          return
        end
        @start_date = parse_and_rewind_date(:start_date)
      end

      def load_end_date
        if params[:protocol].blank? || protocol_params[:end_date].blank?
          render json: { errors: { end_date: ['incorrect or missing'] } }, status: 422
          return
        end
        @end_date = parse_and_rewind_date(:end_date)
      end

      def parse_and_rewind_date(date_key)
        Date.beginning_of_week = :monday
        Date.parse(protocol_params[date_key]).in_time_zone.beginning_of_week
      rescue ArgumentError => e
        render json: { errors: { date_key => [e.message] } }, status: 422
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
