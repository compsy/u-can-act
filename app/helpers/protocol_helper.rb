# frozen_string_literal: true

module ProtocolHelper
  def start_date(start_date_str)
    return Time.zone.now if start_date_str.blank?

    # The start date cannot be in the past.
    [Time.zone.parse(start_date_str), Time.zone.now].max
  end

  def end_date(start_date_str, end_date_str)
    return nil if end_date_str.blank?

    # The duration between start and end date should be at least one hour.
    # There is no specific reason for having a one hour minimum, it's an
    # artibtrary amount of time that should be enough to fill out any questionnaire.
    # The limit is to make it more fool proof, i.e., there's no case in which
    # you would want to start a protocol shorter than one hour (or at least
    # if there is such a case, we don't allow it through this API).
    minimum_end_date = TimeTools.increase_by_duration(start_date(start_date_str), 1.hour)

    [Time.zone.parse(end_date_str), minimum_end_date].max
  end
end
