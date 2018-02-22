# frozen_string_literal: true

class ProtocolSubscription < ApplicationRecord
  include ActiveModel::Validations
  ACTIVE_STATE = 'active'
  CANCELED_STATE = 'canceled'
  COMPLETED_STATE = 'completed'
  belongs_to :person
  belongs_to :filling_out_for, class_name: 'Person', foreign_key: 'filling_out_for_id'
  validates :person_id, presence: true # The person who receives the SMS (Mentor)
  validates :filling_out_for_id, presence: true # Student ID
  belongs_to :protocol
  validates :protocol_id, presence: true
  validates :state, inclusion: { in: [ACTIVE_STATE, CANCELED_STATE, COMPLETED_STATE] }
  validates :start_date, presence: true, start_of_day: true
  validates :end_date, presence: true
  has_many :responses, -> { order open_from: :asc }, dependent: :destroy
  after_create :schedule_responses
  after_initialize :initialize_filling_out_for
  after_initialize :initialize_end_date

  validates_uniqueness_of :filling_out_for_id,
                          scope: %i[person_id state],
                          conditions: -> { where(state: ACTIVE_STATE) },
                          if: ->(sub) { sub.person_id != sub.filling_out_for_id }
  scope :active, (-> { where(state: ACTIVE_STATE) })

  def active?
    state == ACTIVE_STATE
  end

  def cancel!
    update_attributes!(state: CANCELED_STATE, end_date: Time.zone.now)
  end

  def ended?
    Time.zone.now > end_date
  end

  def for_myself?
    person == filling_out_for
  end

  def mentor?
    !for_myself?
  end

  def reward_points
    responses.completed.map { |response| response.measurement.reward_points }.reduce(0, :+)
  end

  def possible_reward_points
    responses.invited.map { |response| response.measurement.reward_points }.reduce(0, :+)
  end

  def max_reward_points
    responses.map { |response| response.measurement.reward_points }.reduce(0, :+)
  end

  def protocol_completion
    on_streak = 0
    responses.map do |response|
      current_streak = -1

      if response.measurement.periodical?
        on_streak = determine_streak(on_streak, response.completed?, response.still_possible?)
        current_streak = on_streak
      end

      create_protocol_completion_entry(response.completed?,
                                       response.measurement.periodical?,
                                       response.measurement.reward_points,
                                       response.still_possible?,
                                       current_streak)
    end
  end

  private

  def determine_streak(streak, current_response_completed, current_response_in_future)
    return streak + 1 if current_response_completed || current_response_in_future
    0
  end

  def create_protocol_completion_entry(is_completed, is_periodical, reward_points, is_in_future, streak)
    result = {}
    result[:completed] = is_completed
    result[:periodical] = is_periodical
    result[:reward_points] = reward_points
    result[:future] = is_in_future
    result[:streak] = streak
    result
  end

  def initialize_filling_out_for
    self.filling_out_for ||= person
  end

  def initialize_end_date
    self.end_date ||= TimeTools.increase_by_duration(start_date, protocol.duration) if
      start_date.present? && protocol.present?
  end

  def schedule_responses
    ActiveRecord::Base.transaction do
      protocol.measurements.each do |measurement|
        schedule_responses_for_measurement(measurement)
      end
    end
  end

  def schedule_responses_for_measurement(measurement)
    open_from = TimeTools.increase_by_duration(start_date, measurement.open_from_offset)
    open_till = measurement_open_till(measurement)
    while open_from < open_till
      Response.create!(protocol_subscription_id: id,
                       measurement_id: measurement.id,
                       open_from: open_from)
      break unless measurement.period
      open_from = TimeTools.increase_by_duration(open_from, measurement.period)
    end
  end

  def measurement_open_till(measurement)
    if measurement.offset_till_end.present?
      TimeTools.increase_by_duration(end_date, - measurement.offset_till_end)
    else
      end_date
    end
  end
end
