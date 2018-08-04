# frozen_string_literal: true

module Api
  module V1
    class ResponseController < ApiController
      # include ::Concerns::IsBasicAuthenticated
      before_action :check_current_user
      before_action :set_person, only: %i[show index]
      before_action :set_response, only: %i[show create]
      before_action :set_responses, only: %i[index show]
      before_action :check_empty_response, only: %i[create]

      def show
        response = @responses.find_by_uuid(params[:uuid])
        render json: response, serializer: Api::PersonalizedQuestionnaireSerializer
      end

      def index
        Rails.logger.info ">>>>>> #{@responses}"
        render json: @responses, each_serializer: Api::ResponseSerializer
      end

      def create
        content = ResponseContent.create!(content: response_content)
        @response.update_attributes!(content: content.id)
        @response.complete!
        head 201
      end

      private

      def check_current_user
        result = { result: 'Not logged in' }
        render(status: 403, json: result) unless current_auth_user.present?
      end

      def set_person
        # Debugging
        # token = request.headers['Authorization'].split.last
        # Knock::AuthToken.new(token: token)

        @person = current_auth_user&.person
        return if @person.present?
        result = { result: 'Deelnemer met dat external id niet gevonden' }
        render(status: 404, json: result)
      end

      def set_responses
        @responses = @person.my_open_responses
        return if @responses.present?
        result = { result: 'Geen responses voor deze persoon gevonden' }
        render(status: 404, json: result)
      end

      def set_response
        @response = Response.find_by_uuid(response_params[:uuid])
        return if @response.present?
        result = { result: 'Response met dat uuid niet gevonden' }
        render(status: 404, json: result)
      end

      def check_empty_response
        return if @response.content.blank?
        result = { result: 'Response met dat uuid heeft al content' }
        render(status: 400, json: result)
      end

      def response_content
        return {} if response_params[:content].nil?
        response_params[:content].to_unsafe_h
      end

      def response_params
        # TODO: change the below line to the following in rails 5.1:
        # params.permit(:response_id, content: {})
        params.permit(:external_identifier, :uuid, content: permit_recursive_params(params[:content]&.to_unsafe_h))
      end
    end
  end
end
