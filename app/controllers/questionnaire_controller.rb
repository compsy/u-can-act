# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]
  before_action :verify_response_id, only: [:create]
  before_action :set_create_response, only: [:create]

  def show
    @response.opened_at = Time.zone.now
    @response.save!
    @content = QuestionnaireGenerator.generate_questionnaire(@response,
                                                             form_authenticity_token(form_options: { action: '/',
                                                                                                     method: 'post' }))
  end

  def create
    response_content = ResponseContent.create!(content: questionnaire_create_params[:content].to_unsafe_h)
    @response.content = response_content.id
    @response.completed_at = Time.zone.now
    @response.save!
    render(status: 200, plain: 'Success')
  end

  private

  def verify_response_id
    return if CookieJar.cookies_set?(cookies.signed) &&
              CookieJar.verify_param(cookies.signed, response_id: questionnaire_create_params[:response_id])
    render(status: 401, plain: 'Je hebt geen toegang tot deze vragenlijst.')
  end

  def questionnaire_create_params
    # TODO: change the below line to the following in rails 5.1:
    # params.permit(:response_id, content: {})
    params.permit(:response_id, content: permit_recursive_params(params[:content].to_unsafe_h))
  end

  def questionnaire_params
    params.permit(:q)
  end

  def permit_recursive_params(params)
    # TODO: remove this function in rails 5.1 (which is already out, but not supported by delayed_job_active_record)
    params.map do |key, value|
      if value.is_a?(Array)
        { key => [permit_recursive_params(value.first)] }
      elsif value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
        { key => permit_recursive_params(value) }
      else
        key
      end
    end
  end

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @response = invitation_token.response
  end

  def set_cookie
    cookie = { response_id: @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def set_create_response
    @response = Response.find_by_id(questionnaire_create_params[:response_id])
    check_response(@response)
  end

  def check_response(response)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return unless response
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if response.expired?
  end

  def check_invitation_token(invitation_token)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return unless invitation_token
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if
      invitation_token.response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if invitation_token.response.expired?
  end
end
