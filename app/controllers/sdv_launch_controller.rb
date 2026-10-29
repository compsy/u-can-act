# frozen_string_literal: true

class SdvLaunchController < ApplicationController
  PLATFORM_SESSION_COOKIE = 'sessionToken'
  RELATIVE_PATH = %r{\A/(?![/\\])[^\\[:space:][:cntrl:]]*\z}

  before_action :check_return_to

  def show
    if platform_user.blank?
      redirect_to "#{ENV.fetch('BASE_PLATFORM_URL', nil)}/login", allow_other_host: true, status: :see_other
      return
    end

    redirect_to return_to, status: :see_other
  end

  private

  def platform_user
    return if cross_site_request?

    JwtAuthenticator.auth_from_platform_cookie(cookies.signed, cookies[PLATFORM_SESSION_COOKIE])
  end

  def return_to
    params[:return_to].presence || questionnaire_index_path
  end

  def check_return_to
    return if return_to.is_a?(String) && RELATIVE_PATH.match?(return_to)

    render(status: :bad_request, plain: 'Invalid return_to')
  end
end
