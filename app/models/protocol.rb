# frozen_string_literal: true

class Protocol < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :duration, numericality: { greater_than_or_equal_to: 0 }
  has_many :measurements, dependent: :destroy
  has_many :protocol_subscriptions, dependent: :destroy
  belongs_to :informed_consent_questionnaire, class_name: 'Questionnaire' # can be nil
  has_many :rewards, -> { order threshold: :asc }, dependent: :destroy

  def calculate_reward(measurement_completion, check_future = false)
    return 0 if rewards.blank? || measurement_completion.blank?
    result = create_multiplier_overview(measurement_completion, check_future)
    result.reduce(0) do |total, value|
      total + (value[:multiplier] * value[:reward_points])
    end
  end


  def find_correct_multiplier(value)
    # Precond: Rewards need to be sorted
    rewards_array = create_rewards_array
    return 1 if rewards.blank?
    index = rewards_array.length - 1
    index -= 1 while value < rewards_array[index].first && index >= 0
    determine_single_reward(value, rewards_array[index].second)
  end

  private

  def create_multiplier_overview(measurement_completion, check_future)
    measurement_completion.map do |current|
      next unless take_current_measurement_into_account?(current[:completed], current[:future], check_future)
      reward_multiplier = determine_reward_multiplier(current[:periodical], current[:streak])
      { multiplier: reward_multiplier, reward_points: current[:reward_points] }
    end.compact
  end

  def take_current_measurement_into_account?(is_completed, is_future, take_future_into_account)
    return true if take_future_into_account
    is_completed && !is_future
  end

  def determine_reward_multiplier(is_periodical, current_streak)
    # If the current entry is not a periodical entry, we want to pay its general amount (i.e., no multiplier)
    return 1 unless is_periodical
    find_correct_multiplier(current_streak)
  end

  def determine_single_reward(value, reward_points)
    value.positive? ? reward_points : 0
  end

  def create_rewards_array
    rewards.map { |rw| [rw.threshold, rw.reward_points] }
  end
end
