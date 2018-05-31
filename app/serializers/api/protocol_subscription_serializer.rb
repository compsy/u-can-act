# frozen_string_literal: true

module Api
  class ProtocolSubscriptionSerializer < ActiveModel::Serializer
    attributes :person_type,
               :protocol_completion,
               :earned_euros,
               :max_still_awardable_euros,
               :euro_delta,
               :current_multiplier,
               :max_streak,
               :initial_multiplier

    def completion
      @completion ||= object.protocol_completion
    end

    def max_streak
      max_streak = object.protocol.max_streak
      return nil if max_streak.blank?
      {
        threshold: max_streak.threshold,
        reward_points: max_streak.reward_points
      }
    end

    def person_type
      object.person.role.group
    end

    def earned_euros
      object.protocol.calculate_reward(completion)
    end

    def max_still_awardable_euros
      object.max_still_earnable_reward_points
    end

    def euro_delta
      latest_streak_value = completion[object.latest_streak_value_index]
      return 0 unless latest_streak_value.present?
      object.protocol.calculate_reward([latest_streak_value])
    end

    def current_multiplier
      current_completion = completion[object.latest_streak_value_index]
      return 1 unless current_completion.present?
      latest_streak_value = completion[object.latest_streak_value_index][:streak]
      object.protocol.find_correct_multiplier(latest_streak_value)
    end

    def initial_multiplier
      object.protocol.rewards&.find_by_threshold(1)&.reward_points || 1
    end
  end
end
