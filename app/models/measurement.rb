# frozen_string_literal: true

class Measurement < ApplicationRecord
  DEFAULT_REMINDER_DELAY = 8.hours
  WEEKDAYS = %w[sunday monday tuesday wednesday thursday friday saturday].freeze
  MIN_PRIORITY = -10_000
  MAX_PRIORITY = 10_000
  # How many responses will at most be scheduled at once for a single protocol subscription
  # by the RescheduleResponses job. Since this job is ran every day, as long as this number is
  # at least as large as the number of responses per day, it will be called again before we run
  # out of responses, so it is all fine. The only issue here is that we use the response count
  # to give people a measure of "completion", which we now have to add a note to that says
  # if there are more than 500 responses to be filled out by the user, this completion count
  # or percentage can be off. (Since it just looks at how many responses were created for
  # a protocol subscription.)
  MAX_RESPONSES = 500

  belongs_to :questionnaire
  belongs_to :protocol # , autosave: true, validate: true
  validate :at_most_one_stop_measurement_per_protocol
  validates :stop_measurement, inclusion: { in: [true, false] }
  validates :should_invite, inclusion: { in: [true, false] }
  # Only redirect if nothing else ready to be filled out (defaults to false).
  validates :only_redirect_if_nothing_else_ready, inclusion: { in: [true, false] }
  # period can be nil, in which case the questionnaire is one-off and not repeated
  validates :period, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }
  # open_duration can be nil, in which case the questionnaire can be filled out until the end of the protocol
  validates :open_duration, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  # either open_from_offset or offset_till_end has to be specified
  validates :open_from_offset, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  # open_from_day is optional, if specified, it means that the open_from_offset (if present) is added to midnight
  # of the specified day. Note that it is allowed (but never needed) to have open_from_offset > 24 hours if an
  # open_from_day is also specified. It just means that if you set open_from_day on a thursday, and open_from_offset
  # to 36 hours, that it will be noon on a friday (which you also could've done with open_from_day friday and
  # open_from_offset 12 hours). If the day of the start_date of the protocol subscription is the same as open_from_day,
  # it will schedule the response for the same day if start_date.beginning_of_day + open_from_offset is
  # equal to or larger than start_date (the start date of the protocol subscription itself). Otherwise, it will be
  # scheduled a week later.
  validates :open_from_day, inclusion: { in: [nil] + WEEKDAYS }
  validates :offset_till_end, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # Highest priority = shown first
  validates :priority, numericality: { only_integer: true, allow_nil: true,
                                       greater_than_or_equal_to: MIN_PRIORITY, less_than_or_equal_to: MAX_PRIORITY }

  validates :reminder_delay, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :collapse_duplicates, inclusion: [true, false]

  # When set to true, if there are previous responses for a similar measurement for the person, the questions will be
  # presented to the user prefilled with the most recent response
  validates :prefilled, inclusion: [true, false]

  validate :either_open_from_or_offset_till_end
  validate :no_otr_and_should_invite

  has_many :responses, dependent: :destroy

  def periodical?
    period.present?
  end

  def response_times(start_date, end_date, open_from_day_uses_start_date_offset)
    return [1.minute.ago.in_time_zone] if protocol.otr_protocol?

    # A periodical measurement is one which is recorded every now and then
    # following some srt of protocol / procedure. These measurements need more
    # responses.
    return periodical_response_times(start_date, end_date, open_from_day_uses_start_date_offset) if periodical?

    # If the offset_till_end is provided, we want the measurement to be open
    # till a certain end date, instead of a start date. This only holds for non
    # periodical questionnaires
    return [open_till(end_date)] if offset_till_end.present?

    [open_from(start_date, open_from_day_uses_start_date_offset)]
  end

  private

  def periodical_response_times(start_date, end_date, open_from_day_uses_start_date_offset)
    response_times = []
    temp_open_from = open_from(start_date, open_from_day_uses_start_date_offset)
    temp_open_till = open_till(end_date)
    while temp_open_from < temp_open_till && response_times.length < MAX_RESPONSES
      response_times << temp_open_from
      temp_open_from = TimeTools.increase_by_duration(temp_open_from, period)
    end

    response_times
  end

  def at_most_one_stop_measurement_per_protocol
    return unless stop_measurement && protocol_id.present?

    protocol.reload
    stop_measurement_already_available = protocol_has_other_stop_measurement?
    protocol.measurements.reset
    return unless stop_measurement_already_available

    errors.add(:protocol, 'can only have a single stop_measurement')
  end

  def protocol_has_other_stop_measurement?
    protocol.stop_measurement.present? && protocol.stop_measurement != self
  end

  def open_till(end_date)
    if offset_till_end.present?
      TimeTools.increase_by_duration(end_date, -offset_till_end)
    else
      end_date
    end
  end

  # Note that this may produce an open_from time that is after the end_date, but only for nonperiodical measurements.
  # This is done on purpose (we assume that if people create a measurement, they want it to run). And it will not exceed
  # the end date by more than a week.
  # Also note that if `open_from_day_uses_start_date_offset` is true, then we use the seconds since midnight of
  # `start_date` instead of the `open_from_offset` as offset for measurements with a defined `open_from_day`.
  def open_from(start_date, open_from_day_uses_start_date_offset)
    new_start_date = start_date.beginning_of_day
    start_date_offset = start_date - new_start_date

    # Regular open time if open_from_day is blank. Because we have measurements with open_from_offsets that can be
    # much larger than 24 hours in which case this math has no point.
    return open_from_with_offset(start_date, false, start_date_offset) if open_from_day.blank?

    # The second check in the guard is for periods that are less than 24 hours. The check fails for some
    # reason if the times are a few nanoseconds apart that's why we check that the difference is more than one second.
    while WEEKDAYS[new_start_date.wday] != open_from_day ||
          (start_date - open_from_with_offset(new_start_date,
                                              open_from_day_uses_start_date_offset, start_date_offset) > 1)
      # We go to the next day, but if it's daylight savings time switches, the next day can be more or less
      # than 24 hours away, so to be sure we first go to noon the next day, and then back to the beginning
      # of that day.
      new_start_date = TimeTools.increase_by_duration(new_start_date, 36.hours).beginning_of_day
    end
    open_from_with_offset(new_start_date, open_from_day_uses_start_date_offset, start_date_offset)
  end

  def open_from_with_offset(start_date, open_from_day_uses_start_date_offset, start_date_offset)
    if open_from_day_uses_start_date_offset
      accumulated_offset = start_date_offset + open_from_offset
      return TimeTools.increase_by_duration(start_date, accumulated_offset) if accumulated_offset.present?

      return start_date
    end
    return TimeTools.increase_by_duration(start_date, open_from_offset) if open_from_offset.present?

    start_date
  end

  def either_open_from_or_offset_till_end
    if periodical?
      open_from_offset_cannot_be_blank
    else
      offsets_cannot_both_be_blank
      offsets_cannot_both_be_present
    end
  end

  def no_otr_and_should_invite
    errors.add(:should_invite, 'cannot be set for an otr protocol') if should_invite? && protocol&.otr_protocol?
  end

  def open_from_offset_cannot_be_blank
    return if open_from_offset.present?

    errors.add(:open_from_offset, 'cannot be blank')
  end

  def offsets_cannot_both_be_blank
    return unless open_from_offset.blank? && offset_till_end.blank?

    errors.add(:open_from_offset, 'cannot be blank if offset_till_end is blank')
    errors.add(:offset_till_end, 'cannot be blank if open_from_offset is blank')
  end

  def offsets_cannot_both_be_present
    return unless open_from_offset.present? && offset_till_end.present?

    errors.add(:open_from_offset, 'cannot be present if offset_till_end is present')
    errors.add(:offset_till_end, 'cannot be present if open_from_offset is present')
  end
end
