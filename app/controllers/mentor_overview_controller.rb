# frozen_string_literal: true

class MentorOverviewController < ApplicationController
  before_action :set_response
  before_action :set_mentor

  def index
    # @my_protocol_subscriptions is currently not used for mentors
    @my_protocol_subscriptions = @mentor.my_protocols
    @student_protocol_subscriptions = @mentor.student_protocols
  end

  private

  def set_response
    response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
    # find_by_id because find raises an error when the object was not found.
    incorrect_id = !response_id || !Response.find_by_id(response_id)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return if incorrect_id
    @response = Response.find(response_id)
  end

  def set_mentor
    person_id = @response.protocol_subscription.person_id
    # find_by_id because find raises an error when the object was not found.
    incorrect_id = !person_id || !Mentor.find_by_id(person_id)
    render(status: 404, plain: 'De mentor kon niet gevonden worden.') && return if incorrect_id
    @mentor = Mentor.find(person_id)
  end
end
