# frozen_string_literal: true

module Api
  class OrganizationOverviewSerializer < ActiveModel::Serializer
    attributes :overview

    def overview
      group = @instance_options[:group]
      object.map do |organization|
        next if organization[:data].blank?
        create_organization_overview_hash(organization, group)
      end.compact
    end

    private

    def create_organization_overview_hash(organization, group)
      completed = 0.0
      total = 0.0
      if organization[:data].keys.include? group
        completed = organization[:data][group][:completed]
        met_threshold_completion = organization[:data][group][:met_threshold_completion]
        total = organization[:data][group][:total]
      end
      {
        name: organization[:name],
        completed: completed,
        met_threshold_completion: met_threshold_completion,
        percentage_completed: calculate_completion_percentage(completed, total)
      }
    end

    def calculate_completion_percentage(completed, total)
      return 0.0 if total.nil? || completed.nil? || (total <= 0)
      (100 * completed.to_d / total.to_d).round
    end
  end
end
