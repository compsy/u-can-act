# frozen_string_literal: true

class Response < ApplicationRecord
  RECENT_PAST = 2.hours
  REMINDER_DELAY = 8.hours
  NOT_SENT_STATE = 'not_sent'
  SENDING_STATE = 'sending'
  SENT_STATE = 'sent'
  SENDING_REMINDER_STATE = 'sending_reminder'
  REMINDER_SENT_STATE = 'reminder_sent'
  belongs_to :protocol_subscription
  validates :protocol_subscription_id, presence: true
  belongs_to :measurement
  validates :measurement_id, presence: true
  validates :open_from, presence: true
  validates :invited_state, inclusion: { in: [NOT_SENT_STATE,
                                              SENDING_STATE,
                                              SENT_STATE,
                                              SENDING_REMINDER_STATE,
                                              REMINDER_SENT_STATE] }
  has_one :invitation_token, dependent: :destroy # has one or none

  after_initialize do |response|
    unless response.uuid
      response.uuid = SecureRandom.uuid
      while Response.where(uuid: response.uuid).count.positive?
        response.uuid = SecureRandom.uuid
      end
    end
  end

  scope :recently_opened_and_not_sent, (lambda {
    where(
      'open_from <= :time_now AND open_from > :recent_past AND invited_state = :not_sent',
      time_now: Time.zone.now,
      recent_past: RECENT_PAST.ago.in_time_zone,
      not_sent: NOT_SENT_STATE
    )
  })
  scope :still_open_and_not_completed, (lambda {
    where(
      'open_from <= :time_now AND open_from > :recent_past AND invited_state = :sent and completed_at IS NULL',
      time_now: Time.zone.now - REMINDER_DELAY,
      recent_past: (RECENT_PAST + REMINDER_DELAY).ago.in_time_zone,
      sent: SENT_STATE
    )
  })
  scope :completed, (-> { where.not(completed_at: nil) })
  scope :invited, (lambda {
    where('invited_state=? OR invited_state=? OR invited_state=?',
          SENT_STATE,
          SENDING_REMINDER_STATE,
          REMINDER_SENT_STATE)
  })

  # De expired check hiervoor staat in de view:
  scope :opened, (lambda {
    where('open_from <= :time_now AND completed_at IS NULL', time_now: Time.zone.now)
  })

  scope :future, (lambda {
    where('open_from > :time_now', time_now: Time.zone.now)
  })

  # rubocop:disable Metrics/AbcSize
  def self.in_week(options = {})
    raise('Only :week_number and :year are valid options!') unless (options.keys - %i[week_number year]).blank?

    # According to
    # https://stackoverflow.com/questions/13075617/rails-3-2-8-how-do-i-get-the-week-number-from-rails,
    # using %U is bad, hence week_number = Time.zone.now.strftime('%U') is off by one.
    # instead, use the Date.cweek function
    week_number = (options[:week_number] || Time.zone.now.to_date.cweek).to_i
    year = (options[:year] || Time.zone.now.year).to_i

    date = Date.commercial(year, week_number, 1).in_time_zone
    between_dates(date.beginning_of_week.in_time_zone, date.end_of_week.in_time_zone)
  end
  # rubocop:enable Metrics/AbcSize

  def self.between_dates(from, to)
    where(
      'open_from <= :end_of_week AND open_from > :start_of_week',
      start_of_week: from, end_of_week: to
    )
  end

  def self.find_by_identifier(identifier, token)
    person = Person.find_by_external_identifier(identifier)
    return nil unless person

    responses = person.protocol_subscriptions&.active&.map { |sub| sub.responses&.invited }.flatten
    return nil if responses.blank?

    responses.each { |resp| return resp if resp.invitation_token&.token == token }
    nil
  end

  def future?
    open_from > Time.zone.now
  end

  def still_possible?
    future? || (!expired? && !completed?)
  end

  def completed?
    completed_at.present?
  end

  def remote_content
    ResponseContent.find(content) if content.present?
  end

  def initialize_invitation_token!
    # If a token exists for this response, reuse that token (so the old SMS invite link still works
    # when sending a reminder). But still recreate the invitation_token object, so we know that the
    # created_at is always when the object was last used. Also, if we don't first destroy the
    # invitation_token, then it will set a different token than what we're giving (since tokens have
    # to be unique).
    invitation_token&.destroy
    create_invitation_token!
    invitation_token.token_plain
  end

  def values
    remote_content&.content
  end

  def expired?
    response_expired? || protocol_subscription.ended?
  end

  def determine_student_mentor
    student = nil
    mentor = nil
    if protocol_subscription.mentor?
      student = protocol_subscription.filling_out_for
      mentor = protocol_subscription.person
    else # we are student
      student = protocol_subscription.person
      mentor = student.role.group == Person::STUDENT ? student.mentor : nil # Student can in theory just be a person
    end
    [student, mentor]
  end

  private

  def response_expired?
    measurement.open_duration.present? &&
      Time.zone.now > TimeTools.increase_by_duration(open_from, measurement.open_duration)
  end
end
