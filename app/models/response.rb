# frozen_string_literal: true

class Response < ApplicationRecord
  RECENT_PAST = 2.hours
  NOT_SENT_STATE = 'not_sent'
  SENDING_STATE = 'sending'
  SENT_STATE = 'sent'
  belongs_to :protocol_subscription
  validates :protocol_subscription_id, presence: true
  belongs_to :measurement
  validates :measurement_id, presence: true
  validates :open_from, presence: true
  validates :invited_state, inclusion: { in: [NOT_SENT_STATE, SENDING_STATE, SENT_STATE] }
  has_one :invitation_token, dependent: :destroy # has one or none

  scope :recently_opened_and_not_sent, (lambda {
    where(
      'open_from <= :time_now AND open_from > :recent_past AND invited_state = :not_sent',
      time_now: Time.zone.now,
      recent_past: RECENT_PAST.ago.in_time_zone,
      not_sent: NOT_SENT_STATE
    )
  })

  # Moet hier nog een check komen voor expired? 
  scope :open, (lambda {
    where( 'open_from <= :time_now AND completed_at IS NULL', time_now: Time.zone.now)
  })

  def remote_content
    ResponseContent.find(content) if content.present?
  end

  def initialize_invitation_token!
    # If a token exists for this response, reuse that token (so the old SMS invite link still works
    # when sending a reminder). But still recreate the invitation_token object, so we know that the
    # created_at is always when the object was last used. Also, if we don't first destroy the
    # invitation_token, then it will set a different token than what we're giving (since tokens have
    # to be unique).
    token = invitation_token&.token
    invitation_token&.destroy
    create_invitation_token!(token: token)
  end

  def values
    remote_content&.content
  end

  def expired?
    response_expired? || protocol_subscription.ended?
  end

  private

  def response_expired?
    measurement.open_duration.present? &&
      Time.zone.now > TimeTools.increase_by_duration(open_from, measurement.open_duration)
  end
end
