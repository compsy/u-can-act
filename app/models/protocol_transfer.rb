# frozen_string_literal: true

class ProtocolTransfer < ApplicationRecord
  belongs_to :protocol_subscription
  belongs_to :from, class_name: 'Person'
  belongs_to :to, class_name: 'Person'

  validates :protocol_subscription, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validate :check_to_from_different

  private

  def check_to_from_different
    errors.add(:from, 'mag niet hetzelfde zijn als to') if from == to
  end
end
