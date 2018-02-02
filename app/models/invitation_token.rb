# frozen_string_literal: true

require 'bcrypt'

class InvitationToken < ApplicationRecord
  include BCrypt
  TOKEN_LENGTH = 4
  OPEN_TIME_FOR_INVITATION = 7.days
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
    @token_plain = new_token
    self.token_hash = @token
  end

  def expired?
    reponse.response_expired? &&
      Time.zone.now > TimeTools.increase_by_duration(Time.zone.now, OPEN_TIME_FOR_INVITATION)
  end

  after_initialize do |invitation_token|
    if invitation_token.id.nil? && !@token_plain.present?
      token = RandomAlphaNumericStringGenerator.generate(InvitationToken::TOKEN_LENGTH)
      invitation_token.token = token
      @token_plain = token
    end
  end
end
