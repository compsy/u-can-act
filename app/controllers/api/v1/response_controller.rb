

# frozen_string_literal: true

module Api
  module V1
    class ResponseController < ApiController
      before_action :authenticate_admin
      before_action :set_person, only: %i[show]
      before_action :set_responses, only: %i[show]

      def show
        render json: @responses, each_serializer: Api::ResponseSerializer
      end

      private

      def set_person
        @person = Person.find_by_external_identifier(params[:external_identifier])
        return if @person.present?
        render(status: 404, json: 'Deelnemer met dat external id niet gevonden')
      end

      def set_responses
        @responses = @person.my_open_responses
        return if @responses.present?
        render(status: 404, json: 'Geen responses voor deze persoon gevonden')
      end
    end
  end
end
