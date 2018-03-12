# frozen_string_literal: true

class RewardController < ApplicationController
  include Concerns::IsLoggedIn
  before_action :set_response
  before_action :set_protocol_subscription

  def index; end

  private

  def set_response
    @response = current_user&.last_completed_response
  end

  def set_protocol_subscription
    unless @response
      render(status: 404, plain: 'Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
    end
    @protocol_subscription = @response.protocol_subscription if @response
  end
end
