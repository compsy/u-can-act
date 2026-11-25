# frozen_string_literal: true

module JwtAuthenticatable
  extend ActiveSupport::Concern

  SAFE_METHODS = %w[GET HEAD OPTIONS].freeze

  included do
    before_action :verify_platform_cookie_origin
  end

  def self.platform_origin
    url_origin(ENV.fetch('BASE_PLATFORM_URL', nil))
  end

  def self.url_origin(url)
    uri = URI.parse(url.to_s)
    return if uri.host.blank?

    "#{uri.scheme}://#{uri.host}#{":#{uri.port}" unless uri.port == uri.default_port}".downcase
  rescue URI::InvalidURIError
    nil
  end

  private

  def token
    params[:token] || request.headers['Authorization']&.split&.last || platform_cookie_token
  end

  def platform_cookie_token
    cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE].to_s.sub(/\ABearer[+\s]+/, '').presence
  end

  def platform_cookie_only?
    params[:token].blank? && request.headers['Authorization'].blank? && platform_cookie_token.present?
  end

  def verify_platform_cookie_origin
    return if SAFE_METHODS.include?(request.request_method) || !platform_cookie_only?
    return if request.xhr? && platform_origin.present? && request_origin == platform_origin

    access_denied(origin: 'Cross-origin request with the platform session cookie is not allowed')
  end

  def request_origin
    request.origin.presence || JwtAuthenticatable.url_origin(request.referer)
  end

  def platform_origin
    JwtAuthenticatable.platform_origin
  end

  def authenticate_auth_user
    unauthorized_entity('auth_user') unless current_auth_user
  end

  def current_auth_user
    return if token.blank?
    return @current_auth_user if defined?(@current_auth_user)

    @current_auth_user = auth_user_from_token
  end

  def auth_user_from_token
    payload, = JWT.decode(token.to_s, JwtAuth.decode_key, true, JwtAuth.decode_options)
    AuthUser.from_token_payload(payload)
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError, JWT::EncodeError
    nil
  end
end
