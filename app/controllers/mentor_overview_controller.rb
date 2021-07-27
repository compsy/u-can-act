# frozen_string_literal: true

class MentorOverviewController < ApplicationController
  include ::IsLoggedIn
  include ::IsLoggedInAsMentor
  before_action :use_mentor_layout

  def index
    # @my_protocol_subscriptions is currently not used for mentors
    @my_protocol_subscriptions = current_user.my_protocols
    @student_protocol_subscriptions = current_user.my_protocols(false)
  end

  private

  def use_mentor_layout
    @use_mentor_layout = true
  end
end
