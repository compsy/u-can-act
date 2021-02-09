# frozen_string_literal: true

class DestroyFutureResponsesJob < ApplicationJob
  queue_as :default

  def perform(protocol_subscription_id)
    protocol_subscription = ProtocolSubscription.find_by(id: protocol_subscription_id)

    # It's possible that the protocol subscription was destroyed,
    # in which case the responses were already removed.
    return unless protocol_subscription

    protocol_subscription.responses.future.destroy_all
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
