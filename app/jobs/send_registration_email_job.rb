# frozen_string_literal: true

class SendRegistrationEmailJob < ApplicationJob
  queue_as :default

  def perform(some_person)
    person = Person.find_by(id: some_person.id)
    return if person.blank?

    EmailRegistration.run!(person: person)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
