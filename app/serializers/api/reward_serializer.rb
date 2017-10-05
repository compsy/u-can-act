# frozen_string_literal: true

module Api
  class RewardSerializer < ActiveModel::Serializer
    attributes :person_type,
               :protocol_completion,
               :earned_euros,
               :max_still_awardable_euros,
               :euro_delta

    def person_type
      object.person.type
    end

    def earned_euros
      completion = object.protocol_completion
      object.protocol.calculate_reward(completion)
    end

    def max_still_awardable_euros
      from = latest_strike_value + 1
      to = from + object.responses.future.length
      range = (from...to).to_a
      object.protocol.calculate_reward(range)
    end

    def euro_delta
      object.protocol.calculate_reward([latest_strike_value])
    end

    private

    def latest_strike_value
      protocol_completion = object.protocol_completion
      completion_index = protocol_completion.find_index(-1)
      return 0 if completion_index.nil? || (completion_index - 1).negative?
      protocol_completion[completion_index - 1]
    end
  end
end
