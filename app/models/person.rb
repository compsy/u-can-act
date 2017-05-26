# frozen_string_literal: true

class Person < ApplicationRecord
  include ActiveModel::Validations
  validates :mobile_phone,
            length: { minimum: 10, maximum: 10 },
            format: /\A\d{10}\z/,
            mobile_phone: true,
            uniqueness: true
  validates :first_name, presence: true
  has_many :protocol_subscriptions, -> { order created_at: :desc }, dependent: :destroy

  def reward_points
    protocol_subscriptions.map(&:reward_points).reduce(0, :+)
  end

  def possible_reward_points
    protocol_subscriptions.map(&:possible_reward_points).reduce(0, :+)
  end

  def max_reward_points
    protocol_subscriptions.map(&:max_reward_points).reduce(0, :+)
  end
end
