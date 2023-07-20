# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class ResponseController < JwtApiController
        before_action :set_response, only: %i[show create]
        before_action :set_my_open_responses, only: %i[index]
        before_action :set_my_completed_responses, only: %i[completed]
        before_action :set_my_responses, only: %i[all]
        before_action :check_empty_response, only: %i[create]

        def index
          render json: @responses, each_serializer: Api::ResponseSerializer
        end

        def show
          render json: @response, serializer: Api::PersonalizedQuestionnaireSerializer
        end

        def all
          render json: @responses, each_serializer: Api::ResponseSerializer
        end

        def create
          content = ResponseContent.create_with_scores!(content: response_content, response: @response)
          @response.update!(content: content.id)
          @response.complete!
          head :created
        end

        def completed
          render json: @responses, each_serializer: Api::ResponseSerializer
        end

        private

        def set_my_completed_responses
          @responses = current_user.my_completed_responses
          return if @responses.present?

          render(status: :ok, json: [])
        end

        def set_my_responses
          @responses = current_user.my_responses
          return if @responses.present?

          render(status: :ok, json: [])
        end

        def set_my_open_responses
          @responses = current_user.my_open_responses
          return if @responses.present?

          render(status: :ok, json: [])
        end

        def set_response
          @response = current_user.responses.find_by(uuid: response_params[:uuid])
          return if @response.present?

          result = { result: 'Response met dat uuid niet gevonden' }
          render(status: :not_found, json: result)
        end

        def check_empty_response
          return if @response.content.blank?

          result = { result: 'Response met dat uuid heeft al content' }
          render(status: :bad_request, json: result)
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
end
