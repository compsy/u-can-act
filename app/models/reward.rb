# frozen_string_literal: true

class Reward < ApplicationRecord
  validates :threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than: 0 }
  validates :protocol, presence: true
  validates_uniqueness_of :threshold, scope: :protocol_id
  belongs_to :protocol
  TOTAL_EARNED_SO_FAR = 'total_earned_so_far'
  CAN_STILL_BE_EARNED = 'can_still_be_earned'

  def self.total_earned_euros(bust_cache: false)
    RedisCachedCall.cache(TOTAL_EARNED_SO_FAR, bust_cache) do
      students = Person.all.reject(&:mentor?)
      earned_reward_points = 0
      students.each do |student|
        earned_reward_points += CalculateEarnedByPerson.run!(person: student)
      end
      earned_reward_points / 100.0
    end
  end

  def self.max_still_earnable_euros(bust_cache: false)
    RedisCachedCall.cache(CAN_STILL_BE_EARNED, bust_cache) do
      students = Person.all.reject(&:mentor?)
      still_earnable_reward_points = 0
      students.each do |student|
        still_earnable_reward_points += (CalculateTotalByPerson.run!(person: student) -
                                         CalculateEarnedByPerson.run!(person: student))
      end
      still_earnable_reward_points / 100.0
    end
  end
end
