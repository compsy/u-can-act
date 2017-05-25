# frozen_string_literal: true

class Mentor < Person
  def my_protocols
    return [] if protocol_subscriptions.blank?
    protocol_subscriptions.active.select { |prot_sub| prot_sub.filling_out_for_id == id }
  end

  def student_protocols
    return [] if protocol_subscriptions.blank?
    protocol_subscriptions.active.reject { |prot_sub| prot_sub.filling_out_for_id == id }
  end
end
