# frozen_string_literal: true

class JwtAuthenticator
  MAX_TOKEN_LIFETIME = 24.hours.to_i

  class << self
    def auth_from_cookies(cookies_signed)
      token = token_from_cookies(cookies_signed)
      auth_with_token(token, cookies_signed)
    end

    def auth_from_params(cookies_signed, params)
      token = decoded_token_from_params(params)
      auth_with_token(token, cookies_signed)
    end

    def engine_cookie_person(cookies_signed)
      token = CookieJar.read_entry(cookies_signed, TokenAuthenticationController::JWT_TOKEN_COOKIE)
      return unless token.is_a?(Array) && token.first.is_a?(Hash)

      AuthUser.find_by(auth0_id_string: token.first['sub'])&.person
    end

    def auth_from_platform_cookie(cookies_signed, platform_cookie)
      token = decode_token(platform_cookie.to_s.sub(/\ABearer[+\s]+/, ''))
      auth_with_token(token, cookies_signed, create_auth_user: true)
    end

    private

    def auth_with_token(token, cookies_signed, create_auth_user: false)
      return if token.blank? || expired?(token.first)

      # TODO: token opslaan in session ipv cookies
      auth_user = find_auth_user(token.first, create_auth_user)
      return if auth_user.blank?

      store_token_in_cookie(token, cookies_signed)
      auth_user.person
    end

    def expired?(payload)
      lifetime = payload['exp'].to_i - payload['iat'].to_i
      payload['exp'].to_i <= Time.now.to_i || !lifetime.between?(1, MAX_TOKEN_LIFETIME)
    end

    def find_auth_user(payload, create_auth_user)
      auth_user = AuthUser.find_by(auth0_id_string: payload['sub'])
      return auth_user if auth_user.present? || !create_auth_user

      AuthUser.from_token_payload(payload) if payload['sub'].present?
    end

    def decoded_token_from_params(params)
      decode_token(token_from_params(params))
    end

    def decode_token(raw_token)
      return if raw_token.blank?

      JWT.decode(raw_token, JwtAuth.token_public_key, true, decode_options)
    rescue JWT::DecodeError => e # if the argument passed is not a JWT token
      Rails.logger.info "Decoding failed: #{e.message}"
      nil
    end

    def decode_options
      options = { algorithms: [ENV.fetch('TOKEN_SIGNATURE_ALGORITHM', nil)] }
      audience = ENV.fetch('AUTH0_CLIENT_ID', nil)
      return options if audience.blank?

      options.merge(aud: audience, verify_aud: true)
    end

    def token_from_cookies(cookies_signed)
      CookieJar.read_entry(cookies_signed, TokenAuthenticationController::JWT_TOKEN_COOKIE)
    end

    def token_from_params(params)
      # frbl: If possible, ditch the :auth params. I believe it does not actually
      # work, as JwtAuthenticatable checks for the params[:token]
      # see http://localhost:3002/api/v1/person/me?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNTcyMjYzMDM4LCJleHAiOjE1NzQ4NTUwMzgsImp0aSI6ImUzMmRiMzkzLWVlNmUtNDlhOC1iNTBlLTViM2IzMjY5YmJhMCJ9.PC9uszCHTcvBQVOrM_1x14CP3AqHEn17AgIqf-pVi9w
      params[:auth] || params[:token]
    end

    def store_token_in_cookie(token, cookies_signed)
      cookie = { TokenAuthenticationController::JWT_TOKEN_COOKIE => token }
      CookieJar.set_or_update_cookie(cookies_signed, cookie)
      # Remove the TokenAuthenticator cookie if set, so that when the token is no
      # longer in the params, we still end up with the JWT token login.
      CookieJar.delete_cookie(cookies_signed, TokenAuthenticationController::PERSON_ID_COOKIE)
    end
  end
end
