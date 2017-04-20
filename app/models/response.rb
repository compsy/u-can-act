# frozen_string_literal: true

class Response < ApplicationRecord
  NOT_SENT_STATE = 'not_sent'
  SENDING_STATE = 'sending'
  SENT_STATE = 'sent'
  belongs_to :protocol_subscription
  validates :protocol_subscription_id, presence: true
  belongs_to :measurement
  validates :measurement_id, presence: true
  serialize :content, Hash
  validates :open_from, presence: true
  validates :invited_state, inclusion: { in: [NOT_SENT_STATE, SENDING_STATE, SENT_STATE] }
  # has_one :invitation_token, dependent: destroy
end
