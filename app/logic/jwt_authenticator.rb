# frozen_string_literal: true

class JwtAuthenticator
  class << self
    def auth_from_cookies(cookies)
      token = token_from_cookies(cookies)
      auth_with_token(token, cookies)
    end

    def auth_from_params(cookies, params)
      token = decoded_token_from_params(params)
      auth_with_token(token, cookies)
    end

    private

    def auth_with_token(token, cookies)
      return if token.blank?

      # TODO: token opslaan in session ipv cookies
      auth_user = AuthUser.find_by(auth0_id_string: token.first['sub'])
      return if auth_user.blank?

      store_token_in_cookie(token, cookies)
      auth_user.person
    end

    def decoded_token_from_params(params)
      if token_from_params(params).present?
        return JWT.decode(token_from_params(params), Knock.token_public_key, true,
                          algorithms: [ENV['TOKEN_SIGNATURE_ALGORITHM']])
      end
      nil
    rescue JWT::DecodeError => e # if the argument passed is not a JWT token
      Rails.logger.info "Decoding failed: #{e.message}"
      nil
    end

    def token_from_cookies(cookies)
      CookieJar.read_entry(cookies, TokenAuthenticationController::JWT_TOKEN_COOKIE)
    end

    def token_from_params(params)
      # frbl: If possible, ditch the :auth params. I believe it does not actually
      # work, as the Knock gem checks for the params[:token]
      # see http://localhost:3002/api/v1/person/me?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNTcyMjYzMDM4LCJleHAiOjE1NzQ4NTUwMzgsImp0aSI6ImUzMmRiMzkzLWVlNmUtNDlhOC1iNTBlLTViM2IzMjY5YmJhMCJ9.PC9uszCHTcvBQVOrM_1x14CP3AqHEn17AgIqf-pVi9w
      params[:auth] || params[:token]
    end

    def store_token_in_cookie(token, cookies)
      cookie = { TokenAuthenticationController::JWT_TOKEN_COOKIE => token }
      CookieJar.set_or_update_cookie(cookies, cookie)
    end
  end
end
