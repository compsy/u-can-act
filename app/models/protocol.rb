# frozen_string_literal: true

class Protocol < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :duration, numericality: { greater_than_or_equal_to: 0 }
  has_many :measurements, dependent: :destroy
  has_many :protocol_subscriptions, dependent: :destroy
  belongs_to :informed_consent_questionnaire, class_name: 'Questionnaire' # can be nil
  has_and_belongs_to_many :rewards, order: 'threshold asc'

  def calculate_reward(measurement_completion)
    return 0 if rewards.blank?

    # Precond: Rewards need to be sorted
    rewards_array = create_rewards_array

    index = 0
    prev = -1
    measurement_completion.reduce(0) do |current, value|
      # Slightly more efficient, we don't have to loop through all elements,
      # because we know the value is less than the previous one, so at most the
      # same reward
      index = rewards_array.length - 1 if value > prev
      prev = value

      current + find_correct_reward(index, value, rewards_array)
    end
  end

  private

  def find_correct_reward(index, value, rewards_array)
    index -= 1 while value < rewards_array[index].first && index >= 0
    determine_single_reward(value, rewards_array[index].second)
  end

  def determine_single_reward(value, reward_points)
    value.positive? ? reward_points : 0
  end

  def create_rewards_array
    rewards.map { |rw| [rw.threshold, rw.reward_points] }
  end
end
