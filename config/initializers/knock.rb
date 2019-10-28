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
  # TODO: Make dynamic
  #config.token_audience = -> { Rails.application.secrets.auth0_client_id }

  ## Signature algorithm
  ## -------------------
  ##
  ## Configure the algorithm used to encode the token
  # TODO: Make dynamic
  #config.token_signature_algorithm = 'RS256'
  config.token_signature_algorithm = 'HS256'


  ## Signature key
  ## -------------
  ##
  ## Configure the key used to sign tokens.
  config.token_secret_signature_key = -> {
    # TODO: Make dynamic
    'd434d8c85454ea40a82300a8e53386e95434551c063757f9c7f99a4938a15192336d9ca4d476cf1ab5757605948b2a32b22745d9957d198a6625b99e5108da9b'
    #OpenSSL::PKey::RSA.new(
      #OpenSSL::X509::Certificate.new(Base64.strict_decode64(Rails.application.secrets.signing_certificate))
    #)
  }

  ## Public key
  ## ----------
  ##
  ## Configure the public key used to decode tokens, if required.
  #jwks_raw = Net::HTTP.get URI(ENV['AUTH0_RSA_DOMAIN'])
  #jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
  #config.token_public_key = OpenSSL::X509::Certificate.new(Base64.decode64(jwks_keys[0]['x5c'].first)).public_key
  #config.token_public_key = OpenSSL::X509::Certificate.new(Base64.strict_decode64(Rails.application.secrets.signing_certificate)).public_key

  #Rails.application.secrets.auth0_client_secret

end
