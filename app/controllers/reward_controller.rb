# frozen_string_literal: true

class RewardController < ApplicationController
  include ::IsLoggedIn
  before_action :set_response
  before_action :set_protocol_subscription
  before_action :set_layout

  def index; end

  private

  def set_response
    @response = current_user&.last_completed_response
    return if @response

    render(status: :not_found,
           html: 'Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.',
           layout: 'application')
  end

  def set_protocol_subscription
    @protocol_subscription = @response.protocol_subscription
  end

  def set_layout
    @use_mentor_layout = current_user&.mentor? || current_user&.solo?
  end
end
