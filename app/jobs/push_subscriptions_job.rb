# frozen_string_literal: true

class PushSubscriptionsJob < ApplicationJob
  queue_as :default

  def perform(response)
    response = Response.find(response.id)
    return unless response.present? && response.completed?

    response.protocol_subscription.protocol.push_subscriptions.each do |push_subscription|
      push_subscription.push_resonse(response)
    end
  end

  def max_attempts
    # Other side will have to check for duplicates
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
