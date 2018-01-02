# frozen_string_literal: true

class RandomAlphaNumericStringGenerator
  def self.generate(length)
    SecureRandom.random_number(36**length).to_s(36).rjust(length, '0')
  end
end
