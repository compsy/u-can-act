# frozen_string_literal: true

module Api
  class TeamOverviewSerializer < ActiveModel::Serializer
    type 'team_overview'
    attributes :overview

    def overview
      group = @instance_options[:group]
      object.filter_map do |team|
        next if team[:data].blank?

        create_team_overview_hash(team, group)
      end
    end

    private

    def create_team_overview_hash(team, group)
      return create_serializable_hash(team[:name], 0.0, 0.0, 0.0, 0.0) unless team[:data].key?(group)

      create_hash_for_team_with_data(team, group)
    end

    def create_hash_for_team_with_data(team, group)
      create_serializable_hash(
        team[:name],
        team[:data][group][:completed] || 0.0,
        team[:data][group][:met_threshold_completion] || 0.0,
        team[:data][group][:percentage_above_threshold] || 0.0,
        team[:data][group][:total] || 0.0
      )
    end

    def create_serializable_hash(name, completed, met_threshold_completion, percentage_threshold, total)
      {
        name: name,
        completed: completed,
        met_threshold_completion: met_threshold_completion,
        percentage_above_threshold: percentage_threshold,
        percentage_completed: calculate_completion_percentage(completed, total)
      }
    end

    def calculate_completion_percentage(completed, total)
      return 0.0 if total.nil? || completed.nil? || (total <= 0)

      (100 * completed.to_d / total.to_d).round
    end
  end
end
