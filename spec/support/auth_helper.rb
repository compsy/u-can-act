# frozen_string_literal: true

module AuthHelper
  def basic_auth(user, password)
    if defined?(request)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
    elsif defined?(page)
      if page.driver.respond_to?(:basic_auth)
        page.driver.basic_auth(user, password)
      elsif page.driver.respond_to?(:basic_authorize)
        page.driver.basic_authorize(user, password)
      elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
        page.driver.browser.basic_authorize(user, password)
      else
        raise "I don't know how to log in with Capybara!"
      end
    else
      raise "I don't know how to log in!"
    end
  end
end
