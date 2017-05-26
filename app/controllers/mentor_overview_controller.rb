# frozen_string_literal: true

class MentorOverviewController < ApplicationController
  before_action :set_mentor

  def index
    @my_protocol_subscriptions = @mentor.my_protocols
    @student_protocol_subscriptions = @mentor.student_protocols
  end

  private

  def set_mentor
    person_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::PERSON_ID_COOKIE)
    correct_id = !person_id || !Mentor.find(person_id)
    render(status: 404, plain: 'Het persoon kon niet gevonden worden') && return if correct_id
    @mentor = Mentor.find(person_id)
  end
end
