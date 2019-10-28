# frozen_string_literal: true

class JwtAuthenticator
  class << self
    def auth(cookies, params)
      token = token_from_cookie_or_params(params, cookies)
      return if token.blank?

      # TODO: token opslaan in session ipv cookies
      store_token_in_cookie(token, cookies)
      Rails.logger.info '!'*100
      Rails.logger.info token
      Rails.logger.info token.first['sub']
      auth_user = AuthUser.find_by(auth0_id_string: token.first['sub'])
      return auth_user.person if auth_user.present?
    end

    private

    def token_from_cookie_or_params(params, cookies)
      # TODO: make generic
      key = 'd434d8c85454ea40a82300a8e53386e95434551c063757f9c7f99a4938a15192336d9ca4d476cf1ab5757605948b2a32b22745d9957d198a6625b99e5108da9b'

      if params[:auth]
        JWT.decode(params[:auth], key, true)
      elsif params[:token]
        JWT.decode(params[:token], key, true)
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
