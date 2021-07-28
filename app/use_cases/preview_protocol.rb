# frozen_string_literal: true

class PreviewProtocol < ActiveInteraction::Base
  object :protocol
  time :future
  time :start_date
  time :end_date # can be nil
  boolean :open_from_day_uses_start_date_offset, default: false

  # Returns the first five responses that would be scheduled for the given protocol.
  def execute
    @responses = []
    schedule_responses
    # Return at most five responses
    @responses.sort_by! { |response| response[:open_from] }
    @responses[0...10]
  end

  private

  def schedule_responses
    protocol.measurements.each do |measurement|
      schedule_responses_for_measurement(measurement)
    end
  end

  def schedule_responses_for_measurement(measurement)
    measurement.response_times(start_date, end_date, open_from_day_uses_start_date_offset).each do |time|
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
