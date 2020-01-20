# frozen_string_literal: true

class CalculateDistributionJob < ApplicationJob
  queue_as :default

  def perform(response_id)
    response = Response.find(response_id)
    return unless response.present? && response.completed?

    CalculateDistribution.run!(questionnaire: response.measurement.questionnaire)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
