class RewardController < ApplicationController
  before_action :verify_response_id
  before_action :set_protocol_subscription

  def show; end

  private

  def verify_response_id
    # TODO: REMOVE ME
    cookies.signed[:response_id] = Person.first.protocol_subscriptions.first.responses.first.id if Rails.env.development?
    return if cookies.signed[:response_id] && Response.find_by_id(cookies.signed[:response_id])
    render(status: 401, plain: 'Je kan deze pagina pas bekijken als je een vragenlijst hebt ingevuld.')
  end

  def set_protocol_subscription
    @protocol_subscription = Response.find_by_id(cookies.signed[:response_id]).protocol_subscription
  end
end
