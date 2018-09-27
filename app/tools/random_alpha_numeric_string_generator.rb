# frozen_string_literal: true

class RandomAlphaNumericStringGenerator
  def self.generate(length)
    return '' if length <= 0

    SecureRandom.random_number(36**length).to_s(36).rjust(length, '0')
  end
end
