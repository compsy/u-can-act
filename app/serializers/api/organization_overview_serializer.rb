# frozen_string_literal: true

module Api
  class OrganizationOverviewSerializer < ActiveModel::Serializer
    type 'organization_overview'
    attributes :overview

    def overview
      group = @instance_options[:group]
      object.filter_map do |organization|
        next if organization[:data].blank?

        create_organization_overview_hash(organization, group)
      end
    end

    private

    def create_organization_overview_hash(organization, group)
      return create_serializable_hash(organization[:name]) unless organization[:data].key?(group)

      create_hash_for_organization_with_data(organization, group)
    end

    def create_hash_for_organization_with_data(organization, group)
      create_serializable_hash(
        organization[:name],
        organization[:data][group][:completed],
        organization[:data][group][:met_threshold_completion],
        organization[:data][group][:total]
      )
    end

    def create_serializable_hash(name, completed = 0.0, met_threshold_completion = 0.0, total = 0.0)
      {
        name: name,
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
