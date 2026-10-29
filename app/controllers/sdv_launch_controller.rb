# frozen_string_literal: true

class SdvLaunchController < ApplicationController
  PLATFORM_SESSION_COOKIE = 'sessionToken'
  RELATIVE_PATH = %r{\A/(?![/\\])[^\\[:space:][:cntrl:]]*\z}

  before_action :check_return_to

  def show
    if platform_user.blank?
      return render(status: :unauthorized, html: 'Je bent niet ingelogd.', layout: 'application') if params[:retry]

      redirect_to platform_login_url, allow_other_host: true, status: :see_other
      return
    end

    redirect_to params[:relaunch] ? relaunched_return_to : return_to, status: :see_other
  end

  private

  def platform_user
    return if cross_site_request?

    JwtAuthenticator.auth_from_platform_cookie(cookies.signed, cookies[PLATFORM_SESSION_COOKIE])
  end

  def platform_login_url
    launch_path = sdv_launch_path({ return_to: return_to, retry: 1, relaunch: params[:relaunch].presence }.compact)
    relaunch_url = "#{ENV.fetch('HOST_URL', nil).presence || request.base_url}#{launch_path}"
    "#{ENV.fetch('BASE_PLATFORM_URL', nil)}/login?#{{ redirect_uri: relaunch_url }.to_query}"
  end

  def relaunched_return_to
    path, query = return_to.split('?', 2)
    "#{path}?#{[query.presence, 'relaunched=1'].compact.join('&')}"
  end

  def return_to
    params[:return_to].presence || questionnaire_index_path
  end

  def check_return_to
    return if return_to.is_a?(String) && RELATIVE_PATH.match?(return_to)

    render(status: :bad_request, plain: 'Invalid return_to')
  end
end
