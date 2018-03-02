# frozen_string_literal: true

require 'bcrypt'

class InvitationToken < ApplicationRecord
  include BCrypt
  TOKEN_LENGTH = 4
  OPEN_TIME_FOR_INVITATION = 7.days
  belongs_to :response
  validates :response_id, presence: true, uniqueness: true
  validates :expires_at, presence: true

  # Don't supply a token on initialize, it will be generated.
  validates :token_hash, presence: true, uniqueness: true

  attr_accessor :token_plain

  after_initialize do |invitation_token|
    unless invitation_token.expires_at
      invitation_token.expires_at = TimeTools.increase_by_duration(Time.zone.now, OPEN_TIME_FOR_INVITATION)
    end

    if invitation_token.id.nil? && !@token_plain.present?
      token = RandomAlphaNumericStringGenerator.generate(InvitationToken::TOKEN_LENGTH)
      invitation_token.token = token
      @token_plain = token
    end
  end

  def self.test_identifier_token_combination(identifier, token)
    person = Person.find_by_external_identifier(identifier)
    return nil unless person

    responses = person.protocol_subscriptions&.active&.map { |sub| sub.responses&.invited }.flatten
    return nil if responses.blank?

    responses.each { |resp| return resp.invitation_token if resp.invitation_token&.token == token }
    nil
  end

  def token
    @token ||= Password.new(token_hash)
  end

  def token=(new_token)
    @token = Password.create(new_token)
    @token_plain = new_token
    self.token_hash = @token
  end

  def expired?
    # If a response is still valid, it should always be possible to fill it out.
    response.response_expired? && Time.zone.now > expires_at
  end
end
