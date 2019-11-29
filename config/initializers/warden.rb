# Used for creating JWT tokens to communicate with the base platform

# Only has been tested to work with HS256 tokens.
Warden::JWTAuth.configure do |config|
  config.algorithm = ENV['TOKEN_SIGNATURE_ALGORITHM']
  config.secret = ENV['AUTH0_SIGNING_CERTIFICATE']
end
