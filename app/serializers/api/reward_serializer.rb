# frozen_string_literal: true

module Api
  class RewardSerializer < ActiveModel::Serializer
    attributes :person_type,
               :protocol_completion,
               :earned_euros,
               :max_still_awardable_euros,
               :euro_delta

    def completion
      @completion ||= object.protocol_completion
    end

    def person_type
      object.person.type
    end

    def earned_euros
      object.protocol.calculate_reward(completion)
    end

    def max_still_awardable_euros
      from = latest_strike_value_index + 1
      to = from + object.responses.future.length
      sliced_completion = completion.slice((from...to))
      object.protocol.calculate_reward(sliced_completion, true)
    end

    def euro_delta
      latest_strike_value = completion[latest_strike_value_index]
      object.protocol.calculate_reward([latest_strike_value])
    end

    private

    def latest_strike_value_index
      completion_index = completion.find_index { |entry| entry[:future] }
      return 0 if completion_index.nil? || (completion_index - 1).negative?
      completion_index - 1
    end
  end
end
