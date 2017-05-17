# frozen_string_literal: true

class CompleteProtocolSubscriptions
  def self.run
    # Since we're modifying the object, find_each would probably not work.
    # find_each isn't needed, since the scope should always be sufficiently small.
    ProtocolSubscription.active.each do |protocol_subscription|
      next unless protocol_subscription.ended?
      protocol_subscription.update_attributes!(state: ProtocolSubscription::COMPLETED_STATE)
    end
  end
end
