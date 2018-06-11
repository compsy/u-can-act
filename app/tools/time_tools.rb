# frozen_string_literal: true

class TimeTools
  class << self
    def increase_by_duration(time_obj, duration)
      new_time = time_obj + duration.to_i
      new_time += time_obj.utc_offset - new_time.utc_offset
      new_time
    end

    def a_time?(value)
      value.is_a?(ActiveSupport::TimeWithZone) || value.is_a?(Time) || value.is_a?(Date) || value.is_a?(DateTime)
    end

    def an_offset?(value)
      value.is_a?(ActiveSupport::Duration) || value.is_a?(Integer)
    end
  end
end
