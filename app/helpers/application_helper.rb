# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout
    'student'
  end

  def current_user
    return @current_user if @current_user.present?
    @current_user ||= TokenAuthenticator.auth(cookies.signed, params)
    @current_user ||= JwtAuthenticator.auth(cookies.signed, params)
    @current_user
  end

  def logo_image
    'logo-default.png'
    # ANDO: Dit moet nog gefixed worden:
    # return 'U_can_act_logo_ZWART.png' if @use_mentor_layout.nil?
    # @use_mentor_layout ? 'U_can_act_logo_CMYK_BLAUW.png' : 'U_can_act_logo_CMYK_GROEN.png'
  end
end
