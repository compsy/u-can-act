# frozen_string_literal: true

module AuthHelper
  def basic_auth(user, password, url = '/')
    if defined?(page)
      AuthHelper.capybara_basic_auth(user, password, page, url)
    else
      AuthHelper.controller_basic_auth(user, password, request)
    end
  end

  def jwt_auth(payload, set_header = true)
    private_key ||= OpenSSL::PKey::RSA.new(
      Base64.strict_decode64(Rails.application.secrets.private_key),
      Rails.application.secrets.private_key_passphrase
    )

    payload['aud'] = Knock.token_audience.call
    id_token = JWT.encode payload, private_key, 'RS256'
    request.headers['Authorization'] = "Bearer #{id_token}" if (set_header)
    id_token
  end

  class << self
    def capybara_basic_auth(user, password, page, url)
      # Commented out to improve test coverage. The other lines are never used.
      # if page.driver.respond_to?(:basic_auth)
      # page.driver.basic_auth(user, password)
      # elsif page.driver.respond_to?(:basic_authorize)
      # page.driver.basic_authorize(user, password)
      # elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      # page.driver.browser.basic_authorize(user, password)
      # else
      page.visit("http://#{user}:#{password}@" \
                 "#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/#{url}")
      # end
    end

    def visit_with_basic_auth(user, password, page, url); end

    def controller_basic_auth(user, password, request)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
    end
  end
end
