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
      sum_over_student_subscriptions(&:earned_euros)
    end
  end

  def self.max_still_earnable_euros(bust_cache: false)
    RedisCachedCall.cache(CAN_STILL_BE_EARNED, bust_cache) do
      sum_over_student_subscriptions { |sub| sub.earned_euros(true) - sub.earned_euros }
    end
  end

  def self.sum_over_student_subscriptions(&block)
    mentors = Person.joins(:role).where(roles: { group: Person::MENTOR })
    ProtocolSubscription
      .where('protocol_subscriptions.person_id = protocol_subscriptions.filling_out_for_id')
      .where.not(person_id: mentors)
      .includes(protocol: :rewards, responses: { measurement: :questionnaire })
      .find_each(batch_size: 500)
      .sum(&block)
  end
  private_class_method :sum_over_student_subscriptions
end
