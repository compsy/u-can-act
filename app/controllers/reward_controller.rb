# frozen_string_literal: true

class RewardController < ApplicationController
  before_action :set_response_if_dev
  before_action :verify_response_id
  before_action :set_protocol_subscription

  def show; end

  private

  def set_response_if_dev
    cookies.signed[:response_id] = Person.first.protocol_subscriptions.first.responses.first.id if
      Rails.env.development?
  end

  def verify_response_id
    # TODO: REMOVE ME
    return if cookies.signed[:response_id] && Response.find_by_id(cookies.signed[:response_id])
    render(status: 401, plain: 'Je kan deze pagina pas bekijken als je een vragenlijst hebt ingevuld.')
  end

  def set_protocol_subscription
    @protocol_subscription = Response.find_by_id(cookies.signed[:response_id]).protocol_subscription
  end
end
