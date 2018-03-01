# frozen_string_literal: true

class Response < ApplicationRecord
  RECENT_PAST = 2.hours
  belongs_to :protocol_subscription
  validates :protocol_subscription_id, presence: true
  belongs_to :measurement
  validates :measurement_id, presence: true
  belongs_to :invitation_set
  validates :open_from, presence: true
  validates :uuid, presence: true, uniqueness: true

  after_initialize do |response|
    next if response.uuid.present?
    loop do
      response.uuid = SecureRandom.uuid
      break if Response.where(uuid: response.uuid).count.zero?
    end
  end

  scope :recently_opened_and_not_invited, (lambda {
    where(
      'open_from <= :time_now AND open_from > :recent_past AND invitation_set_id IS NULL ' \
      'AND completed_at IS NULL',
      time_now: Time.zone.now,
      recent_past: RECENT_PAST.ago.in_time_zone
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

  def self.opened_and_not_expired
    opened.reject(&:expired?)
  end

  scope :future, (lambda {
    where('open_from > :time_now', time_now: Time.zone.now)
  })

  def self.stop_subscription_token(answer_key, answer_value, response_id)
    Digest::SHA256.hexdigest("#{answer_key}|#{answer_value}|#{response_id}|#{ENV['STOP_SUBSCRIPTION_SALT']}")
  end

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

  # TODO: move to invitation_set
  def initialize_invitation_token!
    # If a token exists for this response, reuse that token (so the old SMS invite link still works
    # when sending a reminder). But still recreate the invitation_token object, so we know that the
    # created_at is always when the object was last used. Also, if we don't first destroy the
    # invitation_token, then it will set a different token than what we're giving (since tokens have
    # to be unique).
    pre_token = invitation_token&.token_plain
    invitation_token&.destroy
    create_invitation_token! token: pre_token
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

  def invitation_url(full = true)
    raise 'Cannot generate invitation_url for historical invitation tokens!' if invitation_token.token_plain.blank?
    concatenated_token = "#{protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
    return "?q=#{concatenated_token}" unless full
    "#{ENV['HOST_URL']}?q=#{concatenated_token}"
  end

  def substitute_variables(obj)
    student, mentor = determine_student_mentor
    subs_hash = {
      mentor_title: mentor&.role&.title,
      mentor_gender: mentor&.gender,
      mentor_name: mentor&.first_name,
      organization: student.role.organization.name,
      student_name: student.first_name,
      student_gender: student.gender
    }
    VariableEvaluator.evaluate_obj(obj, subs_hash)
  end

  def response_expired?
    measurement.open_duration.present? &&
      Time.zone.now > TimeTools.increase_by_duration(open_from, measurement.open_duration)
  end
end
