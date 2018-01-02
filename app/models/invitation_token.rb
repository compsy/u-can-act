# frozen_string_literal: true

require 'bcrypt'

class InvitationToken < ApplicationRecord
  include BCrypt
  belongs_to :response
  validates :response_id, presence: true, uniqueness: true
  # Don't supply a token on initialize, it will be generated.
  validates :token_hash, presence: true, uniqueness: true

  attr_accessor :token_plain
  def token
    @token ||= Password.new(token_hash)
  end

  def token=(new_token)
    @token = Password.create(new_token)
    self.token_hash = @token
  end

  after_initialize do |invitation_token|
    unless invitation_token.id
      token = SecureRandom.hex(8)
      invitation_token.token = token
      @token_plain = token
    end
  end
end
