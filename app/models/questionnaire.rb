# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :content, presence: true
  serialize :content, Array
  has_many :measurements, dependent: :destroy
end
