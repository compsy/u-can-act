# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery prepend: true, with: :exception, except: :options
  before_action :work_off_delayed_jobs

  TEST_COOKIE = :test_cookie
  TEST_COOKIE_ENTRY = 'TRUE'

  def page_not_found
    respond_to do |format|
      format.html { render file: Rails.root.join('public/404.html'), layout: nil, status: :not_found }
      format.all  { head :not_found }
    end
  end

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

  def permit_recursive_params(params)
    # TODO: remove this function in rails 5.1 (which is already out, but not supported by delayed_job_active_record)
    return [] if params.blank?

    params.map do |key, _value|
      # if value.is_a?(Array)
      #  { key => [permit_recursive_params(value.first)] }
      # elsif value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
      #  { key => permit_recursive_params(value) }
      # else
      key
      # end
    end
  end

  # Method to render unprocessable entity errors in a consistent way
  # @param resource_errors the errors to render
  def unprocessable_entity(resource_errors)
    render json: {
      errors: [
        {
          status: '422',
          title: 'unprocessable',
          detail: resource_errors,
          code: '100'
        }
      ]
    }, status: :unprocessable_entity
  end
end
