# frozen_string_literal: true

class Mentor < Person
  def students
    return [] if protocol_subscriptions.blank?
    
  end
end
