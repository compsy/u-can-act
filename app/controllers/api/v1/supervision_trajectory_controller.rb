# frozen_string_literal: true

module Api
  module V1
    class SupervisionTrajectoryController < ApiController
      include ::Concerns::IsLoggedIn
      include ::Concerns::IsLoggedInAsMentor

      def index
        render json: SupervisionTrajectory.all, each_serializer: Api::SupervisionTrajectorySerializer
      end
    end
  end
end
