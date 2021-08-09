# frozen_string_literal: true

class PreviewProtocol < ActiveInteraction::Base
  object :protocol
  time :future # supply this as 10.minutes.ago
  time :start_date # precondition: start_date is not in the past.
  time :end_date, default: nil # can be nil. precondition: if not nil, then should be after start_date
  boolean :open_from_day_uses_start_date_offset, default: false

  MAX_PREVIEW_RESPONSE_COUNT = 10

  # Returns the first ten responses that would be scheduled for the given protocol.
  def execute
    @responses = []
    @end_date = end_date
    @end_date = TimeTools.increase_by_duration(start_date, protocol.duration) if @end_date.blank?
    schedule_responses
    # Return at most ten responses
    @responses.sort_by! { |response| response[:open_from] }
    @responses[0...MAX_PREVIEW_RESPONSE_COUNT]
  end

  private

  def schedule_responses
    protocol.measurements.each do |measurement|
      schedule_responses_for_measurement(measurement)
    end
  end

  def schedule_responses_for_measurement(measurement)
    measurement.response_times(start_date, @end_date, open_from_day_uses_start_date_offset).each do |time|
      next if in_past? time

      @responses << { questionnaire: measurement.questionnaire.key,
                      open_from: time }
    end
  end

  def in_past?(time)
    !in_future? time
  end

  def in_future?(time)
    time > future
  end
end
