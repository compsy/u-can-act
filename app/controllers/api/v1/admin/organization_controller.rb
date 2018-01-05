# frozen_string_literal: true

module Api
  module V1
    module Admin
      class OrganizationController < AdminApiController
        def show
          @organization_overview = Organization.organization_overview(week_number, year)
          render json: @organization_overview, serializer: Api::OrganizationOverviewSerializer,
            group: group,
            week_number: week_number,
            year: year
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

        def organization_params
          params.permit(:group, :week_number, :year)
        end
      end
    end
  end
end
