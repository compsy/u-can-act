# frozen_string_literal: true

class Response < ApplicationRecord
  # Keep the RECENT_PAST check at 2 hours. Resolve the voormeting problem by updating
  # the open_duration of the voormeting measurement of the student and mentor protocol
  # to be nil.
  RECENT_PAST = 2.hours
  belongs_to :protocol_subscription
  has_one :person, through: :protocol_subscription
  has_one :protocol, through: :protocol_subscription
  validates :protocol_subscription_id, presence: true
  belongs_to :filled_out_for, class_name: 'Person', optional: true
  belongs_to :filled_out_by, class_name: 'Person', optional: true
  belongs_to :measurement
  validates :measurement_id, presence: true
  belongs_to :invitation_set, optional: true
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
    where('invitation_set_id IS NOT NULL')
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
    raise('Only :week_number and :year are valid options!') if (options.keys - %i[week_number year]).present?

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

  def self.between_dates(from_date, to_date)
    where(
      'open_from <= :end_of_week AND open_from > :start_of_week',
      start_of_week: from_date, end_of_week: to_date
    )
  end

  def self.after_date(date)
    where('open_from > :date', date: date)
  end

  def unsubscribe_url
    Rails.application.routes.url_helpers.questionnaire_path(uuid: uuid)
  end

  def last?
    protocol_subscription.responses.last == self
  end

  def future?
    open_from > Time.zone.now
  end

  def still_possible?
    future? || (!expired? && !completed?)
  end

  def future_or_current?
    future? || !expired?
  end

  def completed?
    completed_at.present?
  end

  def complete!
    update!(completed_at: Time.zone.now,
            filled_out_by: protocol_subscription.person,
            filled_out_for: protocol_subscription.filling_out_for)
  end

  def remote_content
    ResponseContent.find(content) if content.present?
  end

  def values
    remote_content&.content
  end

  def expired?
    response_expired? || protocol_subscription.ended?
  end

  def expires_at
    if measurement.open_duration.present?
      TimeTools.increase_by_duration(open_from, measurement.open_duration)
    else
      protocol_subscription.end_date
    end
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

  def response_expired?
    measurement.open_duration.present? &&
      Time.zone.now > TimeTools.increase_by_duration(open_from, measurement.open_duration)
  end
end
