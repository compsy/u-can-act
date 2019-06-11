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
    @current_user = Person.find_by(external_identifier: person_external_identifier)
  end

  def logo_image
    return Rails.application.config.settings.logo.fallback_logo if @use_mentor_layout.nil?

    mentor_or_student_logo
  end

  private

  def mentor_or_student_logo
    return Rails.application.config.settings.logo.mentor_logo if @use_mentor_layout

    Rails.application.config.settings.logo.student_logo
  end
end
