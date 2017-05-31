# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]

  PERSON_ID_COOKIE = :person_id
  RESPONSE_ID_COOKIE = :response_id
  TYPE_COOKIE = :type

  def show
    redirect_to_questionnaire(@response.protocol_subscription.for_myself?, @response.invitation_token.token)
  end

  private

  def redirect_to_questionnaire(for_myself, token)
    if for_myself
      redirect_to mentor_overview_index_path
    else
      redirect_to questionnaire_path(q: token)
    end
    # render(status: 404, plain: 'De code die opgegeven is hoort niet bij een student of mentor.')
    # end
  end

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @response = invitation_token.response
  end

  def set_cookie
    cookie = {
      PERSON_ID_COOKIE => @response.protocol_subscription.person.id.to_s,
      RESPONSE_ID_COOKIE => @response.id.to_s,
      TYPE_COOKIE => @response.protocol_subscription.person.type.to_s
    }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def check_invitation_token(invitation_token)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return unless invitation_token
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if
      invitation_token.response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if invitation_token.response.expired?
  end

  def questionnaire_params
    params.permit(:q)
  end
end
