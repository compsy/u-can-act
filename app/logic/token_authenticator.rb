# frozen_string_literal: true

class TokenAuthenticator
  class << self
    def auth(cookies, _params)
      person_external_identifier = CookieJar.read_entry(cookies, TokenAuthenticationController::PERSON_ID_COOKIE)
      Person.find_by(external_identifier: person_external_identifier)
    end
  end
end
