# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :check_params
  before_action :check_invitation_token

  RESPONSE_ID_COOKIE = :response_id
  JWT_TOKEN_COOKIE = :jwt_token
  PERSON_ID_COOKIE = :person_id

  def show
    responses = InvitationToken.find_attached_responses(questionnaire_params[:q])
    if responses.blank?
      render(status: :not_found, html: 'Deze link is niet (meer) geldig.', layout: 'application')
      return
    end
    current_person = responses.first.person
    if current_person.mentor? && !responses.first.protocol_subscription.for_myself?
      # If we are a mentor, we want to follow the full logic of the next page finder
      redirect_to questionnaire_index_path
    else
      # If we are a student, we want to give priority to the response from
      # the set we actually clicked on
      redirect_to preference_questionnaire_index_path(uuid: responses.first.uuid)
    end
  end

  private

  def check_invitation_token
    invitation_token = InvitationToken.test_identifier_token_combination(identifier_param, token_param)
    if invitation_token.nil?
      render(status: :unauthorized, html: 'Je bent niet bevoegd om deze vragenlijst te zien.', layout: 'application')
      return
    end

    if invitation_token.expired?
      render(status: :not_found, html: 'Deze link is niet meer geldig.', layout: 'application')
      return
    end
    store_person_cookie(identifier_param)
  end

  def store_person_cookie(identifier)
    cookie = { PERSON_ID_COOKIE => identifier }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
    # Remove the JWTAuthenticator cookie if set, so we log out any other sessions on this browser.
    CookieJar.delete_cookie(cookies.signed, JWT_TOKEN_COOKIE)
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

    render(status: :unauthorized, html: 'Gebruiker / Vragenlijst niet gevonden.', layout: 'application')
  end

  def questionnaire_params
    params.permit(:q)
  end
end
