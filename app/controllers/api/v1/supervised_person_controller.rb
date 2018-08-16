# frozen_string_literal: true

module Api
  module V1
    class SupervisedPersonController < ApiController
      include ::Concerns::IsLoggedIn
      # before_action :check_role_id_for_created_person, only: [:create]
      before_action :load_role
      before_action :load_protocol

      def create
        Rails.logger.info 'ja!'
        Rails.logger.info protocol_params
        Rails.logger.info role_params
        Rails.logger.info person_params

        ActiveRecord::Base.transaction do
          person = create_person
          return if performed?
          subscribe_to_protocols(person)
        end

        render json: person, serializer: Api::PersonSerializer, status: 201
      end

      private

      def create_person
        person = Person.new(person_params)
        person.role = @role
        return person if person.save
        render json: { errors: person.errors }, status: 400
      end

      def subscribe_to_protocols(person)
        ProtocolSubscription.create!(person: person,
                                     protocol: @protocol,
                                     state: ProtocolSubscription::ACTIVE_STATE,
                                     start_date: protocol_params[:start_date],
                                     end_date: protocol_params[:end_date])
        # TODO: Create subscription for mentor
      end

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

      def load_protocol
        @protocol = Protocol.find_by_uuid(protocol_params[:uuid])
        render json: { errors: { protocol_uuid: ['niet gevonden'] } }, status: 400 unless @protocol.present
      end

      def load_role
        @role = Role.find_by_uuid(role_params[:uuid])
        render json: { errors: { role_uuid: ['niet gevonden'] } }, status: 400 unless @role.present
      end

      def role_params
        params.require(:role).permit(:uuid)
      end

      def protocol_params
        params.require(:protocol).permit(:uuid,
                                         :start_date,
                                         :end_date)
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
