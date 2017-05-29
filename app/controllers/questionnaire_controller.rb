# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]
  before_action :check_informed_consent, only: [:show]
  before_action :verify_response_id, only: %i[create create_informed_consent]
  before_action :set_create_response, only: %i[create create_informed_consent]

  def show
    @response.opened_at = Time.zone.now
    @response.save!

    @content = QuestionnaireGenerator.generate_questionnaire(@response.id,
                                                  @response.measurement.questionnaire.content,
                                                  @response.measurement.questionnaire.title,
                                                  'Opslaan',
                                                  '/',
                                                  form_authenticity_token(form_options: { action: '/',
                                                                                          method: 'post' }))
  end

  def create_informed_consent
    @protocol_subscription.informed_consent_given_at = Time.zone.now
    @protocol_subscription.save!
    @response.opened_at = Time.zone.now
    @response.save!
    render :show
  end

  def create
    response_content = ResponseContent.create!(content: questionnaire_create_params[:content].to_unsafe_h)
    @response.content = response_content.id
    @response.completed_at = Time.zone.now
    @response.save!
    redirect_to(mentor_overview_index_path) && return if CookieJar.mentor?(cookies.signed)
    redirect_to klaar_path
  end

  private

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @response = invitation_token.response
    @protocol_subscription = @response.protocol_subscription
    @protocol = @protocol_subscription.protocol
  end

  def check_informed_consent
    return if @protocol.informed_consent_questionnaire.blank? ||
              @protocol_subscription.informed_consent_given_at.present?
    render :informed_consent
  end

  def verify_response_id
    return if CookieJar.cookies_set?(cookies.signed) &&
              CookieJar.verify_param(cookies.signed, response_id: questionnaire_create_params[:response_id])
    render(status: 401, plain: 'Je hebt geen toegang tot deze vragenlijst.')
  end

  def set_create_response
    @response = Response.find_by_id(questionnaire_create_params[:response_id])
    check_response(@response)
    return if performed?
    @protocol_subscription = @response.protocol_subscription
    @protocol = @protocol_subscription.protocol
  end

  def questionnaire_params
    params.permit(:q)
  end

  def questionnaire_create_params
    # TODO: change the below line to the following in rails 5.1:
    # params.permit(:response_id, content: {})
    params.permit(:response_id, content: permit_recursive_params(params[:content]&.to_unsafe_h))
  end

  def permit_recursive_params(params)
    # TODO: remove this function in rails 5.1 (which is already out, but not supported by delayed_job_active_record)
    return [] if params.blank?
    params.map do |key, _value|
      # if value.is_a?(Array)
      #  { key => [permit_recursive_params(value.first)] }
      # elsif value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
      #  { key => permit_recursive_params(value) }
      # else
      key
      # end
    end
  end

  def set_cookie
    cookie = { response_id: @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
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
