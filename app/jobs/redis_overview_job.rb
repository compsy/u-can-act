# frozen_string_literal: true

class RedisOverviewJob < ApplicationJob
  queue_as :default

  def perform
    Team.overview(bust_cache: true)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
