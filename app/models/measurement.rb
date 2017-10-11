# frozen_string_literal: true

class Measurement < ApplicationRecord
  belongs_to :questionnaire
  validates :questionnaire_id, presence: true
  belongs_to :protocol
  validates :protocol_id, presence: true
  # period can be nil, in which case the questionnaire is one-off and not repeated
  validates :period, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  # open_duration can be nil, in which case the questionnaire can be filled out until the end of the protocol
  validates :open_duration, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :open_from_offset, numericality: { only_integer: true }
  validates :reward_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_iterations, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }
  has_many :responses, dependent: :destroy
end
