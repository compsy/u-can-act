# frozen_string_literal: true

class RandomStringGenerator
  class << self
    def generate_alpha_numeric(length)
      return '' if length <= 0

      SecureRandom.random_number(36**length).to_s(36).rjust(length, '0')
    end

    def generate_alphabetical(length)
      return '' if length <= 0

      (0...length).map { rand(97..122).chr }.join
    end
  end
end
