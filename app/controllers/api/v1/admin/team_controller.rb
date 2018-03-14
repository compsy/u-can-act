# frozen_string_literal: true

module Api
  module V1
    module Admin
      class TeamController < AdminApiController
        def show
          @team_overview = Team.overview(week_number, year, percentage_threshold)
          render json: @team_overview,
                 serializer: Api::TeamOverviewSerializer,
                 group: group
        end

        private

        def group
          team_params[:group]
        end

        def week_number
          team_params[:week_number]
        end

        def year
          team_params[:year]
        end

        def percentage_threshold
          team_params[:percentage_threshold]
        end

        def team_params
          params.permit(:group, :week_number, :year, :percentage_threshold)
        end
      end
    end
  end
end
