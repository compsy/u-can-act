# frozen_string_literal: true

class DestroyPersonJob < ApplicationJob
  queue_as :default

  def perform(id)
    person(id)&.destroy!
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end

  private

  def person(id)
    @person ||= Person.find_by(id: id)
  end
end
