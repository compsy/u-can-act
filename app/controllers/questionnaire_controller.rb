# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  MAX_ANSWER_LENGTH = 2048

  before_action :set_response, only: [:show]
  before_action :set_cookie, only: [:show]
  before_action :set_is_mentor, only: [:show]
  before_action :check_informed_consent, only: [:show]
  before_action :set_questionnaire_content, only: [:show]
  before_action :verify_response_id, only: %i[create create_informed_consent]
  before_action :set_create_response, only: %i[create create_informed_consent]
  before_action :check_content_hash, only: [:create]

  def show
    @response.update_attributes!(opened_at: Time.zone.now)
  end

  def create_informed_consent
    @protocol_subscription.informed_consent_given_at = Time.zone.now
    @protocol_subscription.save!
    @response.update_attributes!(opened_at: Time.zone.now)
    redirect_to questionnaire_path(q: @response.invitation_token.token)
  end

  def create
    response_content = ResponseContent.create!(content: questionnaire_content)
    @response.update_attributes!(content: response_content.id, completed_at: Time.zone.now)
    check_stop_subscription unless questionnaire_stop_subscription.blank?
    redirect_to(mentor_overview_index_path) && return unless @protocol_subscription.for_myself?
    redirect_to klaar_path
  end

  private

  def check_stop_subscription
    stop_subscription_hash = questionnaire_stop_subscription
    content = questionnaire_content
    should_stop = false
    stop_subscription_hash.each do |key, value|
      next unless content.has_key?(key)
      expected = Response.stop_subscription_token(key, content[key], @response.id)
      received = value
      are_equal = ActiveSupport::SecurityUtils::secure_compare(expected,received)
      if are_equal
        should_stop = true
        break
      end
    end
    return unless should_stop
    @response.protocol_subscription.cancel!
    flash[:notice] = if @response.protocol_subscription.mentor?
                       "Succes: De begeleiding voor #{@response.protocol_subscription.filling_out_for.first_name} is gestopt."
                     else
                       'Succes: Je hebt je voor de dagboekstudie uitgeschreven. Bedankt voor je deelname!'
                     end
    Rails.logger.error "[Attention] Protocol subscription #{@response.protocol_subscription.id} was stopped by person #{@response.protocol_subscription.person_id}."
  end

  def check_content_hash
    questionnaire_content.each do |k, v|
      if k.to_s.size > MAX_ANSWER_LENGTH || v.to_s.size > MAX_ANSWER_LENGTH
        render(status: 400, plain: 'Het antwoord is te lang en kan daardoor niet worden opgeslagen')
        break
      end
    end
  end

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
    response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
    cookie_person_id = Response.find_by_id(response_id)&.protocol_subscription&.person_id
    params_person_id = Response.find_by_id(questionnaire_create_params[:response_id])&.protocol_subscription&.person_id
    return if cookie_person_id && cookie_person_id == params_person_id
    render(status: 401, plain: 'Je hebt geen toegang tot deze vragenlijst.')
  end

  def set_create_response
    @response = Response.find_by_id(questionnaire_create_params[:response_id])
    check_response(@response)
    return if performed?
    set_cookie # Now that we know the response can be filled out, update the cookies so the redirect works as expected.
    @protocol_subscription = @response.protocol_subscription
    @protocol = @protocol_subscription.protocol
  end

  def set_questionnaire_content
    @content = QuestionnaireGenerator.generate_questionnaire(@response.id,
                                                             @response.measurement.questionnaire.content,
                                                             @response.measurement.questionnaire.title,
                                                             'Opslaan',
                                                             '/',
                                                             form_authenticity_token(form_options: { action: '/',
                                                                                                     method: 'post' }))
  end

  def questionnaire_params
    params.permit(:q)
  end

  def questionnaire_create_params
    # TODO: change the below line to the following in rails 5.1:
    # params.permit(:response_id, content: {})
    params.permit(:response_id, content: permit_recursive_params(params[:content]&.to_unsafe_h),
                                stop_subscription: permit_recursive_params(params[:stop_subscription]&.to_unsafe_h))
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

  def questionnaire_content
    return {} if questionnaire_create_params[:content].nil?
    questionnaire_create_params[:content].to_unsafe_h
  end

  def questionnaire_stop_subscription
    return {} if questionnaire_create_params[:stop_subscription].nil?
    questionnaire_create_params[:stop_subscription].to_unsafe_h
  end

  def set_cookie
    cookie = { TokenAuthenticationController::RESPONSE_ID_COOKIE => @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def set_is_mentor
    @use_mentor_layout = @response.protocol_subscription.person.mentor?
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
