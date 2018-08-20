# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout
    'student'
  end

  def current_user
    return @current_user if @current_user.present?
    person_external_identifier = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::PERSON_ID_COOKIE)
    @current_user = Person.find_by_external_identifier(person_external_identifier)
  end

  def logo_image
    return 'differentiatie_logo.png'
    return 'U_can_act_logo_ZWART.png' if @use_mentor_layout.nil?
    @use_mentor_layout ? 'U_can_act_logo_CMYK_BLAUW.png' : 'U_can_act_logo_CMYK_GROEN.png'
  end
end
