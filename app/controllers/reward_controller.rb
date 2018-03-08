# frozen_string_literal: true

class RewardController < ApplicationController
  include Concerns::IsLoggedIn
  before_action :set_response
  before_action :set_protocol_subscription

  def show; end

  private

  def set_response
    @response = current_user&.last_completed_response
  end

  def set_protocol_subscription
    @protocol_subscription = @response.protocol_subscription if @response
  end
end
