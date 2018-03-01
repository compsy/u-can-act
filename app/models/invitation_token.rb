# frozen_string_literal: true

class InvitationToken < ApplicationRecord
  belongs_to :invitation_set
  validates :invitation_set_id, presence: true
  # Don't supply a token on initialize, it will be generated.
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  after_initialize do |invitation_token|
    unless invitation_token.id
      invitation_token.token = SecureRandom.hex(8) unless invitation_token.token
      while InvitationToken.where(token: invitation_token.token).count.positive?
        invitation_token.token = SecureRandom.hex(8)
      end
    end
  end
end
