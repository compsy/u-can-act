# frozen_string_literal: true

class JwtAuthenticator
  class << self
    def auth(cookies, params)
      token = token_from_cookie_or_params(params, cookies)
      return if token.blank?

      store_token_in_cookie(token, cookies)
      auth_user = AuthUser.find_by_auth0_id_string(token.first['sub'])
      return auth_user.person if auth_user.present?
    end

    private

    def token_from_cookie_or_params(params, cookies)
      if params[:auth]
        JWT.decode(params[:auth], Knock.token_public_key, true)
      else
        CookieJar.read_entry(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
      end

    # Rescue if the argument passed is not a JWT token
    rescue JWT::DecodeError => e
      Rails.logger.info "Decoding failed: #{e.message}"
      nil
    end

    def store_token_in_cookie(token, cookies)
      cookie = { TokenAuthenticationController::JWT_TOKEN_COOKIE => token }
      CookieJar.set_or_update_cookie(cookies, cookie)
    end
  end
end
