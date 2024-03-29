# frozen_string_literal: true

class RescheduleResponses < ActiveInteraction::Base
  object :protocol_subscription
  time :future

  # Reschedules future responses for a protocol subscription
  #
  # @param protocol_subscription [ProtocolSubscription] the current protocol
  #   subscription
  def execute
    # Don't reschedule responses for restricted OTR protocols
    return if protocol_subscription.protocol.restricted_otr_protocol?

    ActiveRecord::Base.transaction do
      protocol_subscription.responses.not_completed.after_date(future).destroy_all
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
    measurement.response_times(protocol_subscription.start_date,
                               protocol_subscription.end_date,
                               protocol_subscription.open_from_day_uses_start_date_offset).each do |time|
      # TODO: We can speed this up by not scheduling responses that are too far in the future
      #       But only for protocols that require rescheduling (e.g., periodical protocols).
      #       Because for other protocols we schedule all responses at once and never do rescheduling.
      next if in_past? time
      next unless measurement_requires_scheduling? measurement

      Response.create(protocol_subscription_id: protocol_subscription.id,
                      measurement_id: measurement.id,
                      open_from: time)
    end
  end

  def in_past?(time)
    !in_future? time
  end

  def in_future?(time)
    time > future
  end

  # We don't want to create the response when the measurement has already been
  # completed in the case of a non-periodical measurement. I.e., if the
  # measurements response was completed, but it is periodical, we would like
  # the new responses
  def measurement_requires_scheduling?(measurement)
    measurement.periodical? ||
      measurement.protocol.otr_protocol? ||
      !measurement_response_completed?(measurement)
  end

  def measurement_response_completed?(measurement)
    protocol_subscription
      .responses
      .completed
      .where(measurement_id: measurement.id)
      .present?
  end
end
