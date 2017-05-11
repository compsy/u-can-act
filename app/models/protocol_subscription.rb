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
  after_create :schedule_responses

  def active?
    state == ACTIVE_STATE
  end

  def ended?
    Time.zone.now > TimeTools.increase_by_duration(start_date, protocol.duration)
  end

  private

  def schedule_responses
    prot_sub_end = TimeTools.increase_by_duration(start_date, protocol.duration)
    ActiveRecord::Base.transaction do
      protocol.measurements.each do |measurement|
        schedule_responses_for_measurement(measurement, prot_sub_end)
      end
    end
  end

  def schedule_responses_for_measurement(measurement, prot_sub_end)
    open_from = TimeTools.increase_by_duration(start_date, measurement.open_from_offset)
    while open_from < prot_sub_end
      Response.create!(protocol_subscription_id: id,
                       measurement_id: measurement.id,
                       open_from: open_from)
      break unless measurement.period
      open_from = TimeTools.increase_by_duration(open_from, measurement.period)
    end
  end
end
