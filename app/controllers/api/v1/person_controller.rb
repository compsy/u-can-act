# frozen_string_literal: true

module Api
  module V1
    class PersonController < ApiController
      include ::Concerns::IsLoggedIn

      def show
        render json: current_user, serializer: Api::PersonSerializer if params[:id] == 'me'
      end
    end
  end
end
