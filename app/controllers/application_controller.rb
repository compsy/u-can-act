# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    return @current_user if @current_user.present?
    person_external_identifier = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::PERSON_ID_COOKIE)
    @current_user = Person.find_by_external_identifier(person_external_identifier)
  end
end
