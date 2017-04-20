# frozen_string_literal: true

class InvitationToken < ApplicationRecord
  belongs_to :response
  validates :response_id, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
end
