# Used for creating JWT tokens to communicate with the base platform

Warden::JWTAuth.configure do |config|
  # config.algorithm = ENV['TOKEN_SIGNATURE_ALGORITHM']
  config.secret = ENV['WARDEN_JWT_SECRET']
end
