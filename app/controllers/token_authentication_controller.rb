# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]

  RESPONSE_ID_COOKIE = :response_id

  def show
    redirect_to_questionnaire(@response.protocol_subscription.for_myself?, @response.invitation_token.token)
  end

  private

  def redirect_to_questionnaire(for_myself, token)
    redirect_url = if for_myself
                     questionnaire_path(q: token)
                   else
                     mentor_overview_index_path
                   end
    redirect_to redirect_url
  end

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @response = invitation_token.response
  end

  def set_cookie
    cookie = { RESPONSE_ID_COOKIE => @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def check_invitation_token(invitation_token)
    check_invitation_token_available(invitation_token)
    # If the protocol subscription is for someone else, it could be the case that there are multiple questionnaires
    # waiting
    return if performed? || !invitation_token.response.protocol_subscription.for_myself?
    check_invitation_token_still_accessible(invitation_token)
  end

  def check_invitation_token_available(invitation_token)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') unless invitation_token
  end

  def check_invitation_token_still_accessible(invitation_token)
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if
      invitation_token.response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if invitation_token.response.expired?
  end

  def questionnaire_params
    params.permit(:q)
  end
end
