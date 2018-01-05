# frozen_string_literal: true

module Api
  class OrganizationOverviewSerializer < ActiveModel::Serializer
    attributes :overview
    attributes :year
    attributes :week_number

    def week_number
      @instance_options[:week_number]
    end
    
    def year
      @instance_options[:year]
    end



    def overview
      group = @instance_options[:group]
      object.map do |organization|
        next if organization[:data].blank?
        create_organization_overview_hash(organization, group)
      end.compact
    end

    private

    def create_organization_overview_hash(organization, group)
      {
        name: organization[:name],
        completed: organization[:data][group][:completed],
        percentage_completed: calculate_completion_percentage(
          organization[:data][group][:completed],
          organization[:data][group][:total]
        )
      }
    end

    def calculate_completion_percentage(completed, total)
      return 0.0 if total.nil? || completed.nil? || (total <= 0)
      (100 * completed.to_d / total.to_d).round
    end
  end
end
