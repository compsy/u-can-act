# frozen_string_literal: true

module Api
  module V1
    class ResponseController < ApiController
      before_action :authenticate_auth_user
      include ::Concerns::IsBasicAuthenticated
      before_action :set_person, only: %i[show index]
      before_action :set_responses, only: %i[index show]

      def show
        response = @responses.find_by_uuid(params[:uuid])
        render json: response, serializer: Api::PersonalizedQuestionnaireSerializer
      end

      def index
        render json: @responses, each_serializer: Api::ResponseSerializer
      end

      def create
        render json: 'Not yet implemented'
      end

      private

      def set_person
        @person = current_auth_user.person
        return if @person.present?
        render(status: 404, json: 'Deelnemer met dat external id niet gevonden')
      end

      def set_responses
        @responses = @person.my_open_responses
        return if @responses.present?
        render(status: 404, json: 'Geen responses voor deze persoon gevonden')
      end

      def response_params
        params.permit(:external_identifier, :uuid)
      end
    end
  end
end
