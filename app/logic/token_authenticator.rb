# frozen_string_literal: true

class TokenAuthenticator
  class << self
    def auth(cookies_signed, _params)
      person_external_identifier = CookieJar.read_entry(cookies_signed, TokenAuthenticationController::PERSON_ID_COOKIE)
      Person.find_by(external_identifier: person_external_identifier) if person_external_identifier
    end
  end
end
