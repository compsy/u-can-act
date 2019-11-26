# frozen_string_literal: true

module ParameterHasher
  def self.generate_hmac(params_arr, params_hsh, shared_secret)
    plain_token = [shared_secret]
    params_arr.each do |param|
      plain_token << params_hsh[param]
    end
    plain_token = plain_token.join('|')
    Digest::SHA256.hexdigest(plain_token)
  end

  def self.generate_hmac_params(params_arr, params_hsh, shared_secret)
    params_hsh.merge(hmac: generate_hmac(params_arr, params_hsh, shared_secret))
  end

  def self.valid_hmac_params?(params_arr, hmac_params_hsh, shared_secret)
    hmac_params_hsh[:hmac].present? &&
      hmac_params_hsh[:hmac] == generate_hmac(params_arr, hmac_params_hsh, shared_secret)
  end
end
