# frozen_string_literal: true

class Reward < ApplicationRecord
  validates :threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than: 0 }
  validates :protocol, presence: true
  validates_uniqueness_of :threshold, scope: :protocol_id
  belongs_to :protocol
end
