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

    if invitation_token.id.nil? && @token_plain.blank?
      token = RandomStringGenerator.generate_alpha_numeric(InvitationToken::TOKEN_LENGTH)
      invitation_token.token = token
      @token_plain = token
    end
  end

  def self.test_token(full_token)
    identifier, token = InvitationToken.split_token(full_token)
    InvitationToken.test_identifier_token_combination(identifier, token)
  end

  def self.test_identifier_token_combination(identifier, token)
    InvitationToken.find_invitation_token(identifier, token)
  end

  def self.split_token(full_token)
    from = Person::IDENTIFIER_LENGTH
    to = Person::IDENTIFIER_LENGTH + InvitationToken::TOKEN_LENGTH
    return nil if full_token.nil? || full_token.length < to

    identifier = full_token[0...from]
    token = full_token[from..to]
    [identifier, token]
  end

  def self.find_attached_responses(full_token)
    identifier, token = InvitationToken.split_token(full_token)
    InvitationToken.find_attached_responses_split(identifier, token)
  end

  def self.find_attached_responses_split(identifier, token)
    find_invitation_token(identifier, token)&.invitation_set&.responses&.sort_by(&:priority_sorting_metric)
  end

  def self.find_invitation_token(identifier, token)
    person = Person.find_by(external_identifier: identifier)
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
    Time.zone.now > expires_at
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
