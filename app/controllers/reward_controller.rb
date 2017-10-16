# frozen_string_literal: true

class RewardController < ApplicationController
  before_action :verify_response_id
  before_action :verify_response_completed
  before_action :set_protocol_subscription

  def show; end

  private

  def verify_response_id
    response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
    @response = Response.find_by_id(response_id)
    return if @response.present?
    render(status: 401, plain: 'Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
  end

  def verify_response_completed
    return if @response.completed_at.present?
    render(status: 400, plain: 'Je kan deze pagina pas bekijken als je de vragenlijst hebt ingevuld.')
  end

  def set_protocol_subscription
    @protocol_subscription = @response.protocol_subscription
  end
end
