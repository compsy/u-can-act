# frozen_string_literal: true

class Person < ApplicationRecord
  include ActiveModel::Validations
  validates :mobile_phone,
            length: { minimum: 10, maximum: 10 },
            format: /\A\d{10}\z/,
            mobile_phone: true,
            uniqueness: true
  validates :first_name, presence: true
  has_many :protocol_subscriptions, -> { order created_at: :desc }, dependent: :destroy
end
