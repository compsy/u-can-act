# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :check_invitation_token

  RESPONSE_ID_COOKIE = :response_id
  PERSON_ID_COOKIE = :person_id

  def show
    redirect_to questionnaire_index_path
  end

  private

  def check_invitation_token
    invitation_token = InvitationToken.test_identifier_token_combination(identifier_param, token_param)
    render(status: 401, plain: 'Je bent niet bevoegd om deze vragenlijst te zien.') && return if invitation_token.nil?
    store_person_cookie(identifier_param)
  end

  def store_person_cookie(identifier)
    cookie = { PERSON_ID_COOKIE => identifier }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
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

  def questionnaire_params
    params.permit(:q)
  end
end
