# frozen_string_literal: true

class ReschedulingJob < ApplicationJob
  queue_as :default

  def perform
    ProtocolSubscription.active.find_each do |protocol_subscription|
      # Since we are rescheduling responses and not creating the responses for the first time,
      # we want a `future` date that is actually in the future, so that we don't accidentally create
      # responses that the user has already filled out. The extra added hour here is to ensure that
      # if there were invitations being sent out by the worker process right now, or are in queue
      # to be sent out, that we leave those unaffected. Again, because the responses have already
      # been scheduled, this should be fine.
      RescheduleResponses.run!(protocol_subscription: protocol_subscription,
                               future: TimeTools.increase_by_duration(Time.zone.now, 1.hour))
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
