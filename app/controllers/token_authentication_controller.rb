# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :check_params
  before_action :check_invitation_token

  RESPONSE_ID_COOKIE = :response_id
  PERSON_ID_COOKIE = :person_id

  def show
    redirect_to questionnaire_index_path
  end

  private

  def check_invitation_token
    invitation_token = InvitationToken.test_identifier_token_combination(identifier_param, token_param)
    if invitation_token.nil?
      render(status: 401, body: 'Je bent niet bevoegd om deze vragenlijst te zien.', layout: 'application')
      return
    end

    if invitation_token.expired?
      render(status: 404, body: 'Deze link is niet meer geldig.', layout: 'application')
      return
    end
    store_person_cookie(identifier_param)
  end

  def store_person_cookie(identifier)
    cookie = { PERSON_ID_COOKIE => identifier }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
    store_verification_cookie
  end

  def identifier_param
    identifier = questionnaire_params[:q]
    identifier[0...Person::IDENTIFIER_LENGTH] if identifier
  end

  def token_param
    identifier = questionnaire_params[:q]
    from = Person::IDENTIFIER_LENGTH
    to = Person::IDENTIFIER_LENGTH + InvitationToken::TOKEN_LENGTH
    identifier[from..to] if identifier
  end

  def check_params
    return if identifier_param.present? && token_param.present?
    render(status: 401, body: 'Gebruiker / Vragenlijst niet gevonden.', layout: 'application')
  end

  def questionnaire_params
    params.permit(:q)
  end
end
