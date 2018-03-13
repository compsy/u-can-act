# frozen_string_literal: true

require 'bcrypt'

class InvitationToken < ApplicationRecord
  include BCrypt
  TOKEN_LENGTH = 4
  OPEN_TIME_FOR_INVITATION = 7.days
  belongs_to :invitation_set
  validates :invitation_set_id, presence: true
  validates :expires_at, presence: true
  # Don't supply a token on initialize, it will be generated.
  validates :token_hash, presence: true

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

    # This is reasonably fast since the invitation_sets of a person
    # are sorted by descending created_at value.
    person.invitation_sets.each do |invitation_set|
      invitation_set.invitation_tokens.each do |invitation_token|
        return invitation_token if invitation_token.token == token
      end
    end

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
    return false if Time.zone.now <= expires_at
    invitation_set.responses.each do |response|
      return false unless response.response_expired?
    end
    true
  end

  def calculate_expires_at
    expiresat = [Time.zone.now, TimeTools.increase_by_duration(created_at, OPEN_TIME_FOR_INVITATION)].max
    invitation_set.responses.each do |response|
      next if response.completed?
      expiresat = [expiresat, response.expires_at].max
    end
    expiresat
  end
end
