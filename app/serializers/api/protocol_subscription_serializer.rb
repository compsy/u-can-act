# frozen_string_literal: true

module Api
  class ProtocolSubscriptionSerializer < ActiveModel::Serializer
    type 'protocol_subscriptions'
    attributes :person_type,
               :protocol_completion,
               :earned_euros,
               :max_still_awardable_euros,
               :euro_delta,
               :current_multiplier,
               :max_streak,
               :initial_multiplier,
               :start_date,
               :end_date,
               :name,
               :questionnaires,
               :first_name,
               :auth0_id_string,
               :id,
               :state

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

    def auth0_id_string
      return object.person.auth_user.auth0_id_string if object.person.auth_user.present?

      ''
    end

    def max_still_awardable_euros
      object.max_still_earnable_reward_points
    end

    def first_name
      object.person.first_name
    end

    def state
      return ProtocolSubscription::CANCELED_STATE if object.state == ProtocolSubscription::CANCELED_STATE
      if object.state == ProtocolSubscription::ACTIVE_STATE && !object.ended?
        return ProtocolSubscription::ACTIVE_STATE
      end
      ProtocolSubscription::COMPLETED_STATE
    end

    def name
      object.protocol.name
    end

    def questionnaires
      object.protocol.measurements.map do |measurement|
        measurement.questionnaire.title.presence || measurement.questionnaire.key.humanize
      end
    end

    def euro_delta
      return 0 if no_streak_detected

      latest_streak_value = completion[object.latest_streak_value_index]
      return 0 if latest_streak_value.blank?

      object.protocol.calculate_reward([latest_streak_value])
    end

    def current_multiplier
      return 1 if no_streak_detected

      current_completion = completion[object.latest_streak_value_index]
      return 1 if current_completion.blank?

      latest_streak_value = current_completion[:streak]
      object.protocol.find_correct_multiplier(latest_streak_value)
    end

    def initial_multiplier
      object.protocol.rewards&.find_by(threshold: 1)&.reward_points || 1
    end

    def no_streak_detected
      object.latest_streak_value_index == -1
    end
  end
end
