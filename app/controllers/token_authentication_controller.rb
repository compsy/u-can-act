# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :check_params
  before_action :check_invitation_token
  before_action :set_all_responses

  RESPONSE_ID_COOKIE = :response_id
  JWT_TOKEN_COOKIE = :jwt_token
  PERSON_ID_COOKIE = :person_id

  def show
    current_person = @attached_responses.first.person
    only_non_completed_responses = InvitationToken.find_attached_responses(questionnaire_params[:q], true)
    if current_person.mentor? &&
       (!@attached_responses.first.protocol_subscription.for_myself? || only_non_completed_responses.blank?)
      # If we are a mentor, and the first response was already filled out or there is no response to fill out,
      # redirect to the mentor dashboard and/or follow the logic of the next page finder.
      redirect_to questionnaire_index_path
    elsif only_non_completed_responses.present?
      # If we are not a mentor or the prot sub is for ourselves, then we want to redirect to the response,
      # but only if it is not yet completed. Otherwise give an error.
      # If we have an open response to redirect to, give priority to the response from
      # the set we actually clicked on (i.e., the first in the invitation set that is still open).
      redirect_to preference_questionnaire_index_path(uuid: only_non_completed_responses.first.uuid)
    else
      # If there are no responses to be filled out, and we are not a mentor, render an error.
      render(status: :not_found, html: 'Deze link is niet (meer) geldig.', layout: 'application')
    end
  end

  private

  def set_all_responses
    @attached_responses = InvitationToken.find_attached_responses(questionnaire_params[:q], false)
    return if @attached_responses.present?

    render(status: :not_found, html: 'Deze link is niet (meer) geldig.', layout: 'application')
  end

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
