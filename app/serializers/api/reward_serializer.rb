# frozen_string_literal: true

module Api
  class RewardSerializer < ActiveModel::Serializer
    attributes :person_type,
               :reward_points,
               :possible_reward_points,
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
      object.protocol.calculate_reward((1..object.responses.invited.length))
    end

    def euro_delta
      protocol_completion = object.protocol_completion
      completion_index = protocol_completion.find_index(-1)
      return 0 if completion_index.nil? || (completion_index - 1).negative?
      object.protocol.calculate_reward([protocol_completion[completion_index - 1]])
    end
  end
end
