# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :people, dependent: :destroy
  has_many :roles, dependent: :destroy
end
