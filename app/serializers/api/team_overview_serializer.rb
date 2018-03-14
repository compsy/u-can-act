# frozen_string_literal: true

module Api
  class TeamOverviewSerializer < ActiveModel::Serializer
    attributes :overview

    def overview
      group = @instance_options[:group]
      object.map do |team|
        next if team[:data].blank?
        create_team_overview_hash(team, group)
      end.compact
    end

    private

    def create_team_overview_hash(team, group)
      return create_serializable_hash(team[:name]) unless team[:data].keys.include? group
      create_hash_for_team_with_data(team, group)
    end

    def create_hash_for_team_with_data(team, group)
      create_serializable_hash(
        team[:name],
        team[:data][group][:completed],
        team[:data][group][:met_threshold_completion],
        team[:data][group][:percentage_above_threshold],
        team[:data][group][:total]
      )
    end

    def create_serializable_hash(name, completed = 0.0, met_threshold_completion = 0.0,
                                 percentage_threshold = 0.0, total = 0.0)
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
