# frozen_string_literal: true

class TimeTools
  def self.increase_by_duration(time_obj, duration)
    new_time = time_obj + duration.to_i
    new_time += time_obj.utc_offset - new_time.utc_offset
    new_time
  end
end
