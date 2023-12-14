# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class OneTimeResponseController < JwtApiController
        before_action :load_one_time_response, only: :show
        before_action :subscribe_person, only: :show
        before_action :set_redirect_url, only: :show

        def index
          render json: OneTimeResponse.all
        end

        def show
          redirect_to @redirect_url
        end

        private

        def subscribe_person
          @one_time_response.subscribe_person(current_user, mentor)
        end

        def set_redirect_url
          @redirect_url = @one_time_response.redirect_url(current_user)
          return if @redirect_url.present?

          render(status: :not_found,
                 json: 'You must have an active protocol subscription to this protocol to be allowed to fill it out.')
        end

        def mentor
          return nil if one_time_response_params[:mentor_id].blank?

          @mentor ||= Person.find_by(id: one_time_response_params[:mentor_id])
        end

        def load_one_time_response
          token = one_time_response_params[:otr]
          render(status: :bad_request, json: 'otr parameter moet opgegeven worden.') && return if token.blank?

          @one_time_response = OneTimeResponse.find_by(token: token)
          return if @one_time_response.present?

          render(status: :not_found, json: 'De vragenlijst kon niet gevonden worden.')
        end

        def one_time_response_params
          params.permit(:otr, :mentor_id)
        end
      end
    end
  end
end
