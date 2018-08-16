# frozen_string_literal: true

module Api
  module V1
    class SupervisedPersonController < ApiController
      include ::Concerns::IsLoggedIn
      # before_action :check_role_id_for_created_person, only: [:create]

      def me
        render json: current_user, serializer: Api::PersonSerializer
      end

      def create
        Rails.logger.info 'ja!'	
        #person = Person.new(person_params)
        #if person.save
          #render json: person, serializer: Api::PersonSerializer, status: 201
        #else
          #render json: { errors: person.errors }, status: 400
        #end
      end

      private

      def check_role_id_for_created_person
        return unless check_correct_rights
        return unless check_role_id_presence
        return unless check_valid_role
      end

      def check_valid_role
        roles = current_user.role.team.roles.where(group: Person::STUDENT)

        # to_s because the rest call gives us a string
        role_ids = roles.map { |role| role.id.to_s }

        if role_ids.exclude? params[:person][:role_id]
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

      def check_role_id_presence
        if params[:person][:role_id].blank?
          render json: { errors: { role_id: ['moet opgegeven zijn'] } }, status: 400
          return false
        end
        true
      end

      def protocol_params
        params.require(:protocol).permit(:name)
      end

      def person_params
        params.require(:person).permit(:first_name,
                                       :last_name,
                                       :email,
                                       :role_id,
                                       :gender,
                                       :mobile_phone)
      end
    end
  end
end
