# frozen_string_literal: true

class Person < ApplicationRecord
  include ActiveModel::Validations
  MALE = 'male'
  FEMALE = 'female'
  validates :mobile_phone,
            length: { minimum: 10, maximum: 10 },
            format: /\A\d{10}\z/,
            mobile_phone: true,
            uniqueness: true
  validates :email,
            format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            allow_blank: true,
            uniqueness: true
  validates :first_name, presence: true
  belongs_to :organization
  validates :organization_id, presence: true
  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  has_many :protocol_subscriptions, -> { order created_at: :desc }, dependent: :destroy
  # Not used right now:
  # has_many :supervised_protocol_subscriptions,
  #          -> { order created_at: :desc },
  #          class_name: 'ProtocolSubscription', foreign_key: 'filling_out_for_id'

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
