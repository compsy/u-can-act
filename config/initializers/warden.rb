# Used for creating JWT tokens to communicate with the base platform

# Only has been tested to work with HS256 and RS256 tokens.
Warden::JWTAuth.configure do |config|
  config.algorithm = ENV['TOKEN_SIGNATURE_ALGORITHM']
  if config.algorithm == 'RS256'
    begin
      config.secret = OpenSSL::PKey::RSA.new(ENV.fetch('DEVISE_JWT_SECRET_KEY', '').gsub('\\n', "\n"))
      config.decoding_secret = OpenSSL::PKey::RSA.new(ENV.fetch('JWT_DECODING_SECRET', '').gsub('\\n', "\n"))
    rescue OpenSSL::PKey::RSAError => e
      # Handle the RSAError that happens when exporting the javascript translations during the build process
      Rails.logger.error("Error loading RSA keys: #{e}")
    end
  else
    config.secret = ENV['AUTH0_SIGNING_CERTIFICATE']
  end
end
