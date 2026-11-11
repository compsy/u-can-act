# frozen_string_literal: true

module JwtAuthenticatable
  extend ActiveSupport::Concern

  private

  def token
    params[:token] || request.headers['Authorization']&.split&.last
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
