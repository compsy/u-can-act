# frozen_string_literal: true

module Api
  class RewardSerializer < ActiveModel::Serializer
    attributes :id, :reward_points, :max_reward_points, :possible_reward_points, :measurement_completion

    def measurement_completion
      on_streak = 0
      object.responses.map do |x|
        next -1 if x.open?
        on_streak = x.completed? ? (on_streak + 1) : 0
        on_streak = [on_streak, ProtocolSubscription::STREAK_POINTS_NEEDED].min
      end
    end
  end
end
