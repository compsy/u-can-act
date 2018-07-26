# frozen_string_literal: true

class RescheduleResponses < ActiveInteraction::Base
  object :protocol_subscription
  time :future, default: TimeTools.increase_by_duration(Time.zone.now, 3.hours)

  # Reschedules future responses for a protocol subscription
  #
  # Params:
  # - protocol_subscription: the current protocol subscription
  def execute
    ActiveRecord::Base.transaction do
      protocol_subscription.responses.after_date(future).destroy_all
      schedule_responses
    end
  end

  private

  def schedule_responses
    protocol_subscription.protocol.measurements.each do |measurement|
      schedule_responses_for_measurement(measurement)
    end
  end

  def schedule_responses_for_measurement(measurement)
    measurement.response_times(protocol_subscription.start_date, protocol_subscription.end_date).each do |time|
      next if current_or_past_time? time
      next if measurement_response_completed_and_not_periodical?
      Response.create!(protocol_subscription_id: protocol_subscription.id,
                       measurement_id: measurement.id,
                       open_from: time)
    end
  end

  def current_or_past_time?(time)
    time <= future
  end

  def measurement_response_completed_and_not_periodical?
    protocol_subscription.responses.completed.where(measurement_id: measurement.id).present? &&
      !measurement.periodical?
  end
end
