# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :teams, dependent: :destroy
end
