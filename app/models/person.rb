# frozen_string_literal: true

class Person < ApplicationRecord
  include ActiveModel::Validations
  MALE = 'male'
  FEMALE = 'female'

  MENTOR = 'Mentor'
  STUDENT = 'Student'

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
  # Not used right now:
  # has_many :supervised_protocol_subscriptions,
  #          -> { order created_at: :desc },
  #          class_name: 'ProtocolSubscription', foreign_key: 'filling_out_for_id'

  after_initialize do |person|
    unless person.id
      unless person.external_identifier
        person.external_identifier = RandomAlphaNumericStringGenerator.generate(Person::IDENTIFIER_LENGTH)
      end
      while Person.where(external_identifier: person.external_identifier).count.positive?
        person.external_identifier = RandomAlphaNumericStringGenerator.generate(Person::IDENTIFIER_LENGTH)
      end
    end
  end

  def mentor?
    role&.group == Person::MENTOR
  end

  def reward_points
    protocol_subscriptions.map(&:reward_points).reduce(0, :+)
  end

  def possible_reward_points
    protocol_subscriptions.map(&:possible_reward_points).reduce(0, :+)
  end

  def max_reward_points
    protocol_subscriptions.map(&:max_reward_points).reduce(0, :+)
  end

  def my_protocols
    return [] if protocol_subscriptions.blank?
    protocol_subscriptions.active.select { |prot_sub| prot_sub.filling_out_for_id == id }
  end

  def for_someone_else_protocols
    return [] if protocol_subscriptions.blank?
    protocol_subscriptions.active.reject { |prot_sub| prot_sub.filling_out_for_id == id }
  end

  def mentor
    warn_for_multiple_mentors
    ProtocolSubscription.where(filling_out_for_id: id).where.not(person_id: id).first&.person
  end

  private

  def warn_for_multiple_mentors
    Rails.logger.warn "[Attention] retrieving one of multiple mentors for student: #{student.id}" if
      ProtocolSubscription.where(filling_out_for_id: id).where.not(person_id: id).count > 1
  end
end
