# frozen_string_literal: true

class OneTimeResponse < ApplicationRecord
  belongs_to :protocol
  validates :protocol_id, presence: true
  validates :token, presence: true, uniqueness: true

  TOKEN_LENGTH = 8

  after_initialize do |one_time_response|
    next if one_time_response.token.present?

    loop do
      one_time_response.token = RandomAlphaNumericStringGenerator.generate(OneTimeResponse::TOKEN_LENGTH)
      break if OneTimeResponse.where(token: one_time_response.token).count.zero?
    end
  end
end
