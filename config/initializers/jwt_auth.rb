# frozen_string_literal: true

module JwtAuth
  mattr_accessor :token_audience
  mattr_accessor :token_signature_algorithm
  mattr_accessor :token_secret_signature_key
  mattr_accessor :token_public_key

  def self.decode_key
    token_public_key || token_secret_signature_key.call
  end

  def self.decode_options
    options = { algorithms: [token_signature_algorithm], verify_expiration: true }
    return options if token_audience.blank?

    options.merge(aud: token_audience.call, verify_aud: true)
  end
end

JwtAuth.token_audience = -> { ENV['AUTH0_CLIENT_ID'] } if ENV['AUTH0_CLIENT_ID'].present?

JwtAuth.token_signature_algorithm = ENV.fetch('TOKEN_SIGNATURE_ALGORITHM', nil)

if JwtAuth.token_signature_algorithm == 'RS256'
  JwtAuth.token_secret_signature_key = lambda {
    OpenSSL::PKey::RSA.new(
      OpenSSL::X509::Certificate.new(Base64.strict_decode64(ENV['AUTH0_SIGNING_CERTIFICATE']))
    )
  }
  JwtAuth.token_public_key = OpenSSL::X509::Certificate.new(
    Base64.strict_decode64(ENV['AUTH0_SIGNING_CERTIFICATE'])
  ).public_key
else
  JwtAuth.token_secret_signature_key = -> { ENV['AUTH0_SIGNING_CERTIFICATE'] }
  JwtAuth.token_public_key = ENV['AUTH0_SIGNING_CERTIFICATE']
end
