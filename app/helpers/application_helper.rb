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

  def created
    render json: {
      result: [
        {
          status: '201',
          title: 'created',
          detail: 'resource created',
          code: '100'
        }
      ]
    }, status: :created
  end

  def no_content
    render json: {
      result: [
        {
          status: '204',
          title: 'no content',
          detail: 'no content provided',
          code: '100'
        }
      ]
    }, status:  :no_content
  end

  private

  def current_user_from_header
    # current_auth_user is not defined if the including class does not
    # include Knock::Authenticable. Hence we need to check if it is
    # actually defined.
    # @note We need to call this function first, and then fail. We cannot just
    #   check if it is defined, as it is generated automatically.
    current_auth_user&.person
  rescue NameError => _e
    nil
  end

  def mentor_or_student_logo
    return Rails.application.config.settings.logo.mentor_logo if @use_mentor_layout

    Rails.application.config.settings.logo.student_logo
  end
end
