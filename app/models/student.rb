# frozen_string_literal: true

class Student < Person
  def mentor
    warn_for_multiple_mentors
    ProtocolSubscription.where(filling_out_for_id: id).where.not(person_id: id).first&.person
  end

  private

  def warn_for_multiple_mentors
    Rails.logger.warn "[Attention] retrieving one of multiple mentors for student: #{student.id}" if
      ProtocolSubscription.where(filling_out_for_id: id).where.not(person_id: id).count > 1
  end
end
