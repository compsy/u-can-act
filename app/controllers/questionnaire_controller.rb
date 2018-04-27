# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  MAX_ANSWER_LENGTH = 2048
  include Concerns::IsLoggedIn
  before_action :redirect_to_next_page, only: [:index]
  before_action :set_response, only: %i[show destroy]
  # TODO: verify cookie for show as well
  before_action :store_response_cookie, only: %i[show]
  before_action :verify_cookie, only: %i[create create_informed_consent]
  before_action :set_is_mentor, only: [:show]
  before_action :check_informed_consent, only: [:show]
  before_action :set_questionnaire_content, only: [:show]
  before_action :set_create_response, only: %i[create create_informed_consent]
  before_action :check_content_hash, only: [:create]

  def index; end

  def show
    @response.update_attributes!(opened_at: Time.zone.now)
  end

  def create_informed_consent
    @protocol_subscription.informed_consent_given_at = Time.zone.now
    @protocol_subscription.save!
    @response.update_attributes!(opened_at: Time.zone.now)
    redirect_to questionnaire_path(uuid: @response.uuid)
  end

  def create
    response_content = ResponseContent.create!(content: questionnaire_content)
    @response.update_attributes!(content: response_content.id)
    @response.complete!
    check_stop_subscription
    redirect_to_next_page
  end

  def destroy
    stop_response = @protocol_subscription.stop_response

    if stop_response.nil?
      stop_protocol_subscription
      return
    end

    # Note, we don't unsubscribe yet. If a person clicks the 'stop' link, the
    # person is redirected to the stop questionnaire. However, as long as the
    # student does not submit that questionnaire, he or she is not unsubscribed
    redirect_to_next_page stop_response
  end

  private

  def check_stop_subscription
    stop_subscription_hash = questionnaire_stop_subscription
    content = questionnaire_content
    # We assume that if a stop measurement is submitted, it is always the last
    # questionnaire of the protocol.
    return stop_protocol_subscription if @response.measurement.stop_measurement?
    return unless stop_subscription_hash.blank?

    should_stop = false
    stop_subscription_hash.each do |key, received|
      next unless content.key?(key)
      expected = Response.stop_subscription_token(key, content[key], @response.id)
      if ActiveSupport::SecurityUtils.secure_compare(expected, received)
        should_stop = true
        break
      end
    end
    return unless should_stop
    stop_protocol_subscription
  end

  def stop_protocol_subscription
    @response.protocol_subscription.cancel!
    flash[:notice] = if @response.protocol_subscription.mentor?
                       "Succes: De begeleiding voor #{@response.protocol_subscription.filling_out_for.first_name} " \
                         'is gestopt.'
                     else
                       'Succes: Je hebt je voor de dagboekstudie uitgeschreven. Bedankt voor je deelname!'
                     end
    Rails.logger.warn "[Attention] Protocol subscription #{@response.protocol_subscription.id} was stopped by " \
      "person #{@response.protocol_subscription.person_id}."
  end

  def check_content_hash
    questionnaire_content.each do |k, v|
      next unless k.to_s.size > MAX_ANSWER_LENGTH || v.to_s.size > MAX_ANSWER_LENGTH
      render(status: 400, html: 'Het antwoord is te lang en kan daardoor niet worden opgeslagen',
             layout: 'application')
      break
    end
  end

  def redirect_to_next_page(first_response = nil)
    first_response ||= current_user.my_open_responses.first
    if first_response.present?
      redirect_to questionnaire_path(uuid: first_response.uuid)
      return
    end

    if current_user.mentor?
      redirect_to mentor_overview_index_path
      return
    end

    redirect_to klaar_path
  end

  def check_informed_consent
    return if @protocol.informed_consent_questionnaire.blank? ||
              @protocol_subscription.informed_consent_given_at.present?
    render :informed_consent
  end

  def verify_cookie
    signed_in_person_id = current_user&.id
    response_cookie_person_id = person_for_response_cookie
    params_person_id = Response.find_by_id(questionnaire_create_params[:response_id])&.protocol_subscription&.person_id
    return if response_cookie_person_id && signed_in_person_id &&
              signed_in_person_id == params_person_id &&
              signed_in_person_id == response_cookie_person_id

    log_cookie
    render(status: 401, html: 'Je hebt geen toegang tot deze vragenlijst.', layout: 'application')
  end

  def person_for_response_cookie
    response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
    Response.find_by_id(response_id)&.protocol_subscription&.person_id
  end

  def set_response
    the_response = Response.find_by_uuid(questionnaire_params[:uuid])
    check_response(the_response)
    return if performed?
    @response = the_response
    set_protocol_and_subscription
  end

  def set_create_response
    @response = Response.find_by_id(questionnaire_create_params[:response_id])
    check_response(@response)
    return if performed?
    # Now that we know the response can be filled out, update the cookies so the redirect works as expected.
    store_response_cookie
    set_protocol_and_subscription
  end

  def set_protocol_and_subscription
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
    params.permit(:uuid, :method)
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

  def store_response_cookie
    cookie = { TokenAuthenticationController::RESPONSE_ID_COOKIE => @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def set_is_mentor
    @use_mentor_layout = @response.protocol_subscription.person.mentor?
  end

  def check_response(response)
    unless response
      render(status: 404, html: 'De vragenlijst kon niet gevonden worden.', layout: 'application')
      return
    end

    # Instead of throwing a 404, just redirect to the next page in line if one is already completed.
    if response.completed_at
      redirect_to_next_page
      return
    end

    # A person should always be able to fill out a stop measurement
    return if !response.expired? || response.measurement.stop_measurement
    flash[:notice] = 'Deze vragenlijst kan niet meer ingevuld worden.'
    redirect_to_next_page
  end
end
