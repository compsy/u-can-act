# frozen_string_literal: true

class HashGenerator
  def self.generate(plaintext, salt: nil)
    plaintext = "#{plaintext}#{salt}" if salt
    Digest::SHA256.hexdigest plaintext
  end
end
