# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout

    'student'
  end

  def current_user
    return @current_user if @current_user.present?

    @current_user ||= current_user_from_header
    @current_user ||= TokenAuthenticator.auth(cookies.signed, params)
    @current_user ||= JwtAuthenticator.auth(cookies.signed, params)
    @current_user
  end

  def logo_image
    return nil if Rails.application.config.settings.hide_logo
    return Rails.application.config.settings.logo.fallback_logo if @use_mentor_layout.nil?

    mentor_or_student_logo
  end

  private

  def current_user_from_header
    # current_auth_user is not defined if the including class does not
    # include Knock::Authenticable. Hence we need to check if it is
    # actually defined.
    current_auth_user&.person if defined? current_auth_user
  end

  def mentor_or_student_logo
    return Rails.application.config.settings.logo.mentor_logo if @use_mentor_layout

    Rails.application.config.settings.logo.student_logo
  end
end
