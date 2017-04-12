# frozen_string_literal: true

class Protocol < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :duration, numericality: { greater_than_or_equal_to: 0 }
end
