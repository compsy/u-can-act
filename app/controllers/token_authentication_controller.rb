# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]

  def show
    redirect_to_questionnaire(@response.protocol_subscription.person.type, @response.invitation_token.token)
  end

  private

  def redirect_to_questionnaire(person_type, token)
    case person_type
    when 'Mentor'
      redirect_to mentor_overview_path(q: token)
    when 'Student'
      redirect_to questionnaire_path(q: token)
    else
      render(status: 404, plain: 'De code die opgegeven is hoort niet bij een student of mentor')
    end
  end

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @response = invitation_token.response
  end

  def set_cookie
    cookie = {
      person_id: @response.protocol_subscription.person.id.to_s,
      response_id: @response.id.to_s,
      type: @response.protocol_subscription.person.type.to_s
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
