# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery prepend: true, with: :exception, except: :options

  TEST_COOKIE = :test_cookie
  TEST_COOKIE_ENTRY = 'TRUE'

  def options
    head :ok
  end

  def log_cookie
    cookies_enabled = CookieJar.read_entry(cookies.signed, ApplicationController::TEST_COOKIE) == TEST_COOKIE_ENTRY
    msg = cookies_enabled ? 'Cookies are enabled' : 'Cookies are NOT enabled for this user!'
    Rails.logger.info msg
  end

  def store_verification_cookie
    cookie = { TEST_COOKIE => TEST_COOKIE_ENTRY }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end
end
