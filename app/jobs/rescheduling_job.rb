# frozen_string_literal: true

class ReschedulingJob < ApplicationJob
  queue_as :default

  def perform
    ProtocolSubscription.active.find_each do |protocol_subscription|
      RescheduleResponses.run!(protocol_subscription: protocol_subscription)
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
