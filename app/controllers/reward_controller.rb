# frozen_string_literal: true

class RewardController < ApplicationController
  include Concerns::IsLoggedIn
  before_action :set_response
  before_action :set_protocol_subscription

  def index; end

  private

  def set_response
    @response = current_user&.last_completed_response
    unless @response
      render(status: 404, plain: 'Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
    end
  end

  def set_protocol_subscription
    @protocol_subscription = @response.protocol_subscription
  end
end
