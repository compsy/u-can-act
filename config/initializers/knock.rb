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
  if ENV['AUTH0_CLIENT_ID'].present? && Rails.application.secrets.auth0_client_id.present?
    config.token_audience = -> { Rails.application.secrets.auth0_client_id }
  end

  ## Signature algorithm
  ## -------------------
  ##
  ## Configure the algorithm used to encode the token
  # 'RS256' or 'HS256'
  config.token_signature_algorithm = ENV['TOKEN_SIGNATURE_ALGORITHM']


  ## Signature key
  ## -------------
  ##
  ## Configure the key used to sign tokens.
  if config.token_signature_algorithm == 'RS256'
    config.token_secret_signature_key = -> {
      OpenSSL::PKey::RSA.new(
        OpenSSL::X509::Certificate.new(Base64.strict_decode64(Rails.application.secrets.signing_certificate))
      )
    }
  elsif
    config.token_secret_signature_key = -> {
      Rails.application.secrets.signing_certificate
    }
  end

  ## Public key
  ## ----------
  ##
  ## Configure the public key used to decode tokens, if required.
  #jwks_raw = Net::HTTP.get URI(ENV['AUTH0_RSA_DOMAIN'])
  #jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
  #config.token_public_key = OpenSSL::X509::Certificate.new(Base64.decode64(jwks_keys[0]['x5c'].first)).public_key

  # Only set the public key if we use cert based auth
  if ENV['TOKEN_SIGNATURE_ALGORITHM'] == 'RS256'
    config.token_public_key = OpenSSL::X509::Certificate.new(Base64.strict_decode64(Rails.application.secrets.signing_certificate)).public_key
  else
    # If we have a no-certificate based authentication, the private key is used
    # to verify the signatures.
    config.token_public_key = Rails.application.secrets.signing_certificate
  end

  #Rails.application.secrets.auth0_client_secret

end
