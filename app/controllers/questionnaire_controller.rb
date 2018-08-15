# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  MAX_ANSWER_LENGTH = 2048
  include Concerns::IsLoggedIn
  protect_from_forgery prepend: true, with: :exception, except: :create
  before_action :log_csrf_error, only: %i[create]
  before_action :set_response, only: %i[show destroy]
  # TODO: verify cookie for show as well
  before_action :store_response_cookie, only: %i[show]
  before_action :verify_cookie, only: %i[create create_informed_consent]
  before_action :set_is_mentor, only: [:show]
  before_action :check_informed_consent, only: [:show]
  before_action :set_questionnaire_content, only: [:show]
  before_action :set_create_response, only: %i[create create_informed_consent]
  before_action :check_content_hash, only: [:create]

  def index
    redirect_to NextPageFinder.get_next_page current_user: current_user
  end

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
    redirect_to questionnaire_create_params[:callback_url] || NextPageFinder.get_next_page(current_user: current_user,
                                                                                           previous_response: @response)
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
    redirect_to NextPageFinder.get_next_page current_user: current_user, next_response: stop_response
  end

  private

  def check_stop_subscription
    # We assume that if a stop measurement is submitted, it is always the last
    # questionnaire of the protocol.
    return stop_protocol_subscription if @response.measurement.stop_measurement?
    stop_subscription_hash = questionnaire_stop_subscription
    content = questionnaire_content
    return if stop_subscription_hash.blank?

    # NOTE: When a questionnaire has a "stop subscription" question, it bypasses the
    #       stop measurement (i.e., the protocol subscription will be stopped without
    #       requiring its stop measurement to be filled out). So only use "stop subscription"
    #       questions in protocols that don't have a stop_measurement. (Maybe check this
    #       in model validations).
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
                       'Je hebt je uitgeschreven voor het u-can-act onderzoek. Bedankt voor je inzet!'
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

  def check_informed_consent
    render :informed_consent if @protocol_subscription.needs_informed_consent?
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
    @content = QuestionnaireGenerator
               .generate_questionnaire(
                 response_id: @response.id,
                 content: @response.measurement.questionnaire.content,
                 title: @response.measurement.questionnaire.title,
                 submit_text: 'Opslaan',
                 action: '/',
                 unsubscribe_url: Rails.application.routes.url_helpers.questionnaire_path(uuid: @response.uuid),
                 params: default_questionnaire_params
               )
  end

  def default_questionnaire_params
    {
      authenticity_token: form_authenticity_token(form_options: { action: '/', method: 'post' }),
      callback_url: questionnaire_params[:callback_url]
    }
  end

  def questionnaire_params
    params.permit(:uuid, :method, :callback_url)
  end

  def questionnaire_create_params
    # TODO: change the below line to the following in rails 5.1:
    # params.permit(:response_id, content: {})
    params.permit(:response_id,
                  :callback_url,
                  content: permit_recursive_params(params[:content]&.to_unsafe_h),
                  stop_subscription: permit_recursive_params(params[:stop_subscription]&.to_unsafe_h))
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
      redirect_to NextPageFinder.get_next_page current_user: current_user
      return
    end

    # A person should always be able to fill out a stop measurement
    return if !response.expired? || response.measurement.stop_measurement
    flash[:notice] = 'Deze vragenlijst kan niet meer ingevuld worden.'
    redirect_to NextPageFinder.get_next_page current_user: current_user
  end

  def log_csrf_error
    return if valid_request_origin? && any_authenticity_token_valid?
    record_warning_in_rails_logger
    params['content']['csrf_failed'] = 'true' if params['content'].present?
  end

  def record_warning_in_rails_logger
    Rails.logger.warn "[Attention] CSRF error for user #{current_user&.id} at " \
                      "#{request.fullpath} with params: #{params.pretty_inspect}"
  end
end
