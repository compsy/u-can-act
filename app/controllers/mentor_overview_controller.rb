# frozen_string_literal: true

class MentorOverviewController < ApplicationController
  before_action :set_mentor

  def index
    # @my_protocol_subscriptions is currently not use for mentors
    @my_protocol_subscriptions = @mentor.my_protocols
    @student_protocol_subscriptions = @mentor.student_protocols
  end

  private

  def set_mentor
    person_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::PERSON_ID_COOKIE)
    incorrect_id = !person_id || !Mentor.find(person_id)
    render(status: 404, plain: 'De persoon kon niet gevonden worden.') && return if incorrect_id
    @mentor = Mentor.find(person_id)
  end
end
