Knock.setup do |config|

  ## Expiration claim
  ## ----------------
  ##
  ## How long before a token is expired. If nil is provided, token will
  ## last forever.
  ##
  ## Default:
  # config.token_lifetime = 1.day

  ## Audience claim
  ## --------------
  ##
  ## Configure the audience claim to identify the recipients that the token
  ## is intended for.
  ## If using Auth0:
  config.token_audience = -> { Rails.application.secrets.auth0_client_id }

  ## Signature algorithm
  ## -------------------
  ##
  ## Configure the algorithm used to encode the token
  config.token_signature_algorithm = 'RS256'


  ## Signature key
  ## -------------
  ##
  ## Configure the key used to sign tokens.
  config.token_secret_signature_key = -> {
    OpenSSL::PKey::RSA.new(
      OpenSSL::X509::Certificate.new(Base64.strict_decode64(Rails.application.secrets.signing_certificate))
    )
    #Rails.application.secrets.auth0_client_secret
  }

  ## Public key
  ## ----------
  ##
  ## Configure the public key used to decode tokens, if required.
  #jwks_raw = Net::HTTP.get URI(ENV['AUTH0_RSA_DOMAIN'])
  #jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
  #config.token_public_key = OpenSSL::X509::Certificate.new(Base64.decode64(jwks_keys[0]['x5c'].first)).public_key
  config.token_public_key = OpenSSL::X509::Certificate.new(Base64.strict_decode64(Rails.application.secrets.signing_certificate)).public_key
  
  #Rails.application.secrets.auth0_client_secret
  
end
