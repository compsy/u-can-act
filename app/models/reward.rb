# frozen_string_literal: true

class Reward < ApplicationRecord
  validates :threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than: 0 }
  validates :threshold, uniqueness: { scope: :protocol_id }
  belongs_to :protocol
  TOTAL_EARNED_SO_FAR = 'total_earned_so_far'
  CAN_STILL_BE_EARNED = 'can_still_be_earned'

  def self.total_earned_euros(bust_cache: false)
    RedisCachedCall.cache(TOTAL_EARNED_SO_FAR, bust_cache) do
      students = Person.all.reject(&:mentor?)
      students.sum { |student| CalculateEarnedEurosByPerson.run!(person: student) }
    end
  end

  def self.max_still_earnable_euros(bust_cache: false)
    RedisCachedCall.cache(CAN_STILL_BE_EARNED, bust_cache) do
      students = Person.all.reject(&:mentor?)
      students.sum do |student|
        CalculateMaximumEurosByPerson.run!(person: student) - CalculateEarnedEurosByPerson.run!(person: student)
      end
    end
  end
end
