# frozen_string_literal: true

class Protocol < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :measurements, dependent: :destroy
  has_many :protocol_subscriptions, dependent: :destroy
  belongs_to :informed_consent_questionnaire, class_name: 'Questionnaire' # can be nil
end
