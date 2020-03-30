# frozen_string_literal: true

class AsyncActiveInteractionJob < ApplicationJob
  queue_as :default

  # rubocop:disable Security/MarshalLoad
  def perform(sself, serialized_args)
    args = Marshal.load(serialized_args).first
    klass = Object.const_get(sself)
    klass.run!(args)
  end
  # rubocop:enable Security/MarshalLoad

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
