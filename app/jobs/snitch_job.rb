# frozen_string_literal: true

class SnitchJob < ApplicationJob
  queue_as :default

  def perform
    Snitcher.snitch(ENV['SNITCH_KEY'])
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
