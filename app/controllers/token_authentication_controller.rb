# frozen_string_literal: true

class TokenAuthenticationController < ApplicationController
  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]

  RESPONSE_ID_COOKIE = :response_id

  def show
    redirect_to_questionnaire(@response.protocol_subscription.for_myself?, @response.uuid)
  end

  private

  def redirect_to_questionnaire(for_myself, uuid)
    redirect_url = if for_myself
                     questionnaire_path(uuid)
                   else
                     mentor_overview_index_path
                   end
    redirect_to redirect_url
  end

  def set_response
    the_response = Response.find_by_identifier(questionnaire_params[:u], questionnaire_params[:q])
    check_response(the_response)
    return if performed?
    @response = the_response
  end

  def set_cookie
    cookie = { RESPONSE_ID_COOKIE => @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def check_response(response)
    check_response_available(response)
    # If the protocol subscription is for someone else, it could be the case that there are multiple questionnaires
    # waiting
    return if performed? || !response.protocol_subscription.for_myself?
    check_response_still_accessible(response)
  end

  def check_response_available(response)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') unless response
  end

  def check_response_still_accessible(response)
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if response.expired?
  end

  def identifier_param
    questionnaire_params[:u]
  end

  def token_param
    questionnaire_params[:q]
  end

  def questionnaire_params
    params.permit(:u, :q)
  end
end
