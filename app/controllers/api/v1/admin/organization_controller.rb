# frozen_string_literal: true

module Api
  module V1
    module Admin
      class OrganizationController < AdminApiController
        def show
          @organization_overview = Organization.overview(week_number, year, percentage_threshold)
          render json: @organization_overview,
                 serializer: Api::OrganizationOverviewSerializer,
                 group: group
        end

        private

        def group
          organization_params[:group]
        end

        def week_number
          organization_params[:week_number]
        end

        def year
          organization_params[:year]
        end

        def percentage_threshold
          organization_params[:percentage_threshold]
        end

        def organization_params
          params.permit(:group, :week_number, :year, :percentage_threshold)
        end
      end
    end
  end
end
