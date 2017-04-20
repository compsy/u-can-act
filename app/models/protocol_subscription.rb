# frozen_string_literal: true

class ProtocolSubscription < ApplicationRecord
  include ActiveModel::Validations
  ACTIVE_STATE = 'active'
  CANCELED_STATE = 'canceled_state'
  COMPLETED_STATE = 'completed_state'
  belongs_to :person
  validates :person_id, presence: true
  belongs_to :protocol
  validates :protocol_id, presence: true
  validates :state, inclusion: { in: [ACTIVE_STATE, CANCELED_STATE, COMPLETED_STATE] }
  validates :start_date, presence: true, start_of_day: true
  has_many :responses, dependent: :destroy
end
