# frozen_string_literal: true

class MentorOverviewController < ApplicationController
  before_action :set_response
  before_action :set_mentor
  before_action :set_is_mentor

  def index
    # @my_protocol_subscriptions is currently not used for mentors
    @my_protocol_subscriptions = @mentor.my_protocols
    @student_protocol_subscriptions = @mentor.for_someone_else_protocols
  end

  private

  def set_response
    response_id = CookieJar.read_entry(cookies.signed, TokenAuthenticationController::RESPONSE_ID_COOKIE)
    # find_by_id because find raises an error when the object was not found.
    correct_id = response_id.present? && Response.find_by_id(response_id).present?
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return unless correct_id
    @response = Response.find(response_id)
  end

  def set_is_mentor
    @use_mentor_layout = @response.protocol_subscription.person.mentor?
  end

  def set_mentor
    person_id = @response.protocol_subscription.person_id
    # find_by_id because find raises an error when the object was not found.
    person = Person.find_by_id(person_id)
    unless person.present? && person.role.group == Person::MENTOR
      render(status: 404, plain: 'De mentor kon niet gevonden worden.')
    end
    @mentor = person
  end
end
