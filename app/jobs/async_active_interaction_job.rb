# frozen_string_literal: true

class AsyncActiveInteractionJob < ApplicationJob
  queue_as :default

  def perform(sself, *args)
    klass = Object.const_get(sself)
    klass.run!(*args)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
