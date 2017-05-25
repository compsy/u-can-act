# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :content, presence: true
  serialize :content, Array
  has_many :measurements, dependent: :destroy
  has_many :informed_consent_protocols, class_name: 'Protocol', dependent: :nullify,
                                        foreign_key: 'informed_consent_questionnaire_id'
end
