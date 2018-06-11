# frozen_string_literal: true

class Person < ApplicationRecord
  include ActiveModel::Validations
  MALE = 'male'
  FEMALE = 'female'

  MENTOR = 'Mentor'
  STUDENT = 'Student'
  DEFAULT_PERCENTAGE = 70

  IDENTIFIER_LENGTH = 4

  validates :mobile_phone,
            length: { minimum: 10, maximum: 10 },
            format: /\A\d{10}\z/,
            mobile_phone: true,
            uniqueness: true
  validates :email,
            format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            allow_blank: true,
            uniqueness: true
  validates :external_identifier,
            format: /\A[a-z0-9]{#{IDENTIFIER_LENGTH}}\z/i,
            allow_blank: false,
            uniqueness: true
  validates :first_name, presence: true
  belongs_to :role
  validates :role_id, presence: true
  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  has_many :protocol_subscriptions, -> { order created_at: :desc }, dependent: :destroy
  has_many :invitation_sets, -> { order created_at: :desc }, dependent: :destroy # invitation_sets.first is
  # Not used right now:                                                           the last one created.
  # has_many :supervised_protocol_subscriptions,
  #          -> { order created_at: :desc },
  #          class_name: 'ProtocolSubscription', foreign_key: 'filled_out_for_id'

  after_initialize do |person|
    next if person.external_identifier
    loop do
      person.external_identifier = RandomAlphaNumericStringGenerator.generate(Person::IDENTIFIER_LENGTH)
      break if Person.where(external_identifier: person.external_identifier).count.zero?
    end
  end

  def last_completed_response
    protocol_subscriptions.map { |x| x.responses.completed }
                          .flatten
                          .max_by(&:completed_at)
  end

  def mentor?
    role&.group == Person::MENTOR
  end

  def reward_points
    protocol_subscriptions.sum(&:reward_points)
  end

  def possible_reward_points
    protocol_subscriptions.sum(&:possible_reward_points)
  end

  def max_reward_points
    protocol_subscriptions.sum(&:max_reward_points)
  end

  def max_still_earnable_reward_points
    protocol_subscriptions.active.sum(&:max_still_earnable_reward_points)
  end

  def my_protocols(for_myself = true)
    return [] if protocol_subscriptions.blank?
    return protocol_subscriptions.active.select { |prot_sub| prot_sub.filling_out_for_id == id } if for_myself
    protocol_subscriptions.active.reject { |prot_sub| prot_sub.filling_out_for_id == id }
  end

  def my_open_responses(for_myself = true)
    responses = my_protocols(for_myself).map { |prot| prot.responses.opened_and_not_expired }.flatten
    responses.sort_by(&:open_from)
  end

  def mentor
    warn_for_multiple_mentors
    ProtocolSubscription.active.where(filling_out_for_id: id).where.not(person_id: id).first&.person
  end

  def stats(week_number, year, threshold_percentage)
    person_completed = 0
    person_total = 0
    protocol_subscriptions.active.each do |subscription|
      past_week = subscription.responses.in_week(week_number: week_number, year: year)
      person_completed += past_week.completed.count || 0
      person_total += past_week.count || 0
    end
    {
      met_threshold_completion: check_threshold(person_completed, person_total, threshold_percentage),
      completed: person_completed,
      total: person_total
    }
  end

  private

  def check_threshold(completed, total, threshold_percentage)
    return 0 unless total.positive?
    threshold_percentage ||= Person::DEFAULT_PERCENTAGE
    threshold_percentage = threshold_percentage.to_i
    actual_percentage = completed.to_d / total.to_d * 100
    actual_percentage >= threshold_percentage ? 1 : 0
  end

  def warn_for_multiple_mentors
    Rails.logger.warn "[Attention] retrieving one of multiple mentors for student: #{id}" if
    ProtocolSubscription.active.where(filling_out_for_id: id).where.not(person_id: id).count > 1
  end
end
