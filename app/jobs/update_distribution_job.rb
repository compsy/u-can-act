# frozen_string_literal: true

class UpdateDistributionJob < ApplicationJob
  queue_as :default

  def perform(response_id)
    response = Response.find(response_id)
    return unless response.present? && response.completed?

    questionnaire = response.measurement.questionnaire
    RedisMutex.with_lock("Distribution:#{questionnaire.key}") do
      UpdateDistribution.run!(questionnaire: questionnaire,
                              response: response)
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
