# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :check_params
  before_action :check_invitation_token
  before_action :set_attached_responses
  before_action :set_response_to_redirect_to

  RESPONSE_ID_COOKIE = :response_id
  JWT_TOKEN_COOKIE = :jwt_token
  PERSON_ID_COOKIE = :person_id

  def show
    current_person = @attached_responses.first.person
    if @response_to_redirect_to.blank?
      # If all responses for this invitation set were filled out,
      if current_person.mentor?
        # then a mentor can still use the link
        # from their invitation to view the mentor dashboard. Note that the link is only valid as long
        # as the InvitationToken is valid (and expired Invitation tokens by default expire after 7 days).
        # So this guarantees that any mentor can use any link sent to them for 7 days to get to their
        # mentor dashboard, even if they filled out all responses.
        redirect_to questionnaire_index_path
      else
        # A regular user however has no dashboard to go to, so if there are no more responses to fill out,
        # their invitation link will render a 404 error.
        render(status: :not_found, html: 'Deze link is niet (meer) geldig.', layout: 'application')
      end
      return
    end
    # We know now that we have at least one response to fill out. We prefer to redirect to the first one
    # of this set (note that these responses are ordered by the {Response#priority_sorting_metric}).
    # If we are a mentor and the first response to be filled out is for a student, then redirect to the
    # mentor dashboard instead.
    if current_person.mentor? && !@response_to_redirect_to.protocol_subscription.for_myself?
      redirect_to questionnaire_index_path
    else
      # If we are not a mentor or the response to be filled out is for ourselves,
      # redirect to the response.
      redirect_to preference_questionnaire_index_path(uuid: @response_to_redirect_to.uuid)
    end
  end

  private

  def set_attached_responses
    @attached_responses = InvitationToken.find_attached_responses(questionnaire_params[:q], false)
    return if @attached_responses.present?

    render(status: :not_found, html: 'Deze link is niet (meer) geldig.', layout: 'application')
  end

  def set_response_to_redirect_to
    @response_to_redirect_to = InvitationToken.find_attached_responses(questionnaire_params[:q], true).first

    # I think if you return false or nil from a before_action, it stops the rendering?
    true
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
